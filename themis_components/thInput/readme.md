# Input — `thInput`

## Description

Add your input fields with a little style.

- Unlike `<input>`, `<th-input>` must be explictly closed. This is a browser enforced limitation of custom elements.

- Plenty of options can be passed into your input including.. Icons, Postfix, Prefix

  - icons
  - postfix
  - prefix


- `<input>` attributes can be passed in like you normally would:

  - name
  - placeholder
  - value
  - type
  - id

---

## Notes

- If adding an icon to your input field you *cannot* also add a prefix as they exist in the same space.
  - Any [Font Awesome](https://fortawesome.github.io/Font-Awesome/icons/ "icons!") font can be used by just passing in the relevant name. ex: `icon="dollar"` for `'fa fa-dollar'`
- This component is mainly useful for text input ex: `type="text"` `type="password"` but also works great for a file selector ex: `type="file"`


