# MongoDB: document modeling

Load this from `SKILL.md` section 0 when designing or changing collections. Model for the queries the spec needs, not for the entities alone.

## Embed or reference
| Embed (subdocument or array) when | Reference (store the `_id`) when |
|---|---|
| It is read with the parent nearly every time | It is read or updated on its own |
| It belongs to one parent only | Many parents share it (many-to-many) |
| The count is small and bounded (addresses, line items) | It grows without a limit (comments, events, logs) |
| It changes together with the parent | It changes often and independently |

- **No unbounded arrays.** A document is capped at 16 MB and large arrays slow every update. Growing children go in their own collection with a parent id field and an index on it.
- Duplicating a few fields (e.g. author name on a post) is fine when reads far outnumber changes. Write down who updates the copy.
- One collection per entity type. Don't put different shapes in one collection unless a `type` field and the queries need it.
- `_id`: keep the default `ObjectId` unless a natural key is truly immutable.

## Common shapes
- **One-to-few:** embed an array.
- **One-to-many:** child collection with `parentId` plus an index on it.
- **Many-to-many:** an array of ids on the side with fewer entries, or a link collection if the relation has its own fields.
- **Tree / hierarchy:** `parentId` plus an `ancestors` array when you need subtree queries.

## Validation
Add a `$jsonSchema` validator (in the migration script), e.g.:
```js
db.createCollection("users", { validator: { $jsonSchema: {
  bsonType: "object", required: ["email", "createdAt"],
  properties: { email: { bsonType: "string", pattern: "^.+@.+$" }, createdAt: { bsonType: "date" } }
} }, validationLevel: "strict", validationAction: "error" })
```
For an existing collection use `collMod` with the same validator. Start with `validationAction: "warn"` if old documents may not match, fix them, then switch to `error`.

## Checklist
- [ ] Every query in the spec maps to one collection read, plus at most one `$lookup` or second query.
- [ ] Every array that can grow has a known ceiling, or it lives in its own collection.
- [ ] Each query has an index (`SKILL.md` section 4); unique natural keys have unique indexes.
- [ ] Dates are BSON dates and money is `Decimal128` or integer cents, never floats.
