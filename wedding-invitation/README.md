# Lace envelope-fold invitation: Meher & Marlon, Valley of Fire, May 20, 2027

One 3D-printed lace sheet that **folds into its own envelope** and **opens into a full-page invitation**.

- **Folded:** 6½ × 3½ in (165 × 90 mm), about the size of a #6¾ envelope, closed with a monogram wax seal.
- **Opened:** a 6½ × 9¾ in page (165 × 246 mm). It has three panels:
  - **Top flap:** the only lace, a fine lace border with small cut-out flowers along the pointed edge, and a small script monogram on the inside.
  - **Middle panel:** six short lines of small, widely spaced gold capitals with one script "&" and a gold hairline. The rest of the panel is left empty.
  - **Bottom panel:** four corner slits hold a **5 × 2½ in paper details card**.

## Design notes
The direction is modern and minimal: quiet luxury, editorial typography, and lots of empty space.
- **Two typefaces only:** Cinzel capitals and a Great Vibes "&".
- **Small type:** capitals are 2 to 3.3 mm tall, which is about as small as engraved lettering can be printed reliably.
- **Even letter spacing:** each letter is placed by its real width from the font (`fonts/cinzel_widths.scad`), so the spacing stays even.
- **Restrained lace:** the lace is an accent on the flap only, not a border around everything.

| Closed | Opened | As printed |
|---|---|---|
| ![](renders/closed.png) | ![](renders/open.png) | ![](renders/print_flat.png) |

## Files
- `stl/envelope_invitation_body.stl`: the whole sheet (ivory / white), one piece
- `stl/envelope_invitation_inlay_gold.stl`: optional 0.6 mm gold inlay for the lettering
- `invitation.scad`: editable source (wording, panel sizes, card size)
- `tools/build.sh`: rebuilds the STLs. `tools/previews.sh` rebuilds the images. `tools/glyph_widths.py` regenerates the letter-width table.

## Printing
- **Bed:** the sheet is 165 × 246 mm, so it fits 250 × 250 mm and 256 × 256 mm beds. Print it as exported, **inside face down**. No supports are needed.
- **Material:** PETG is best for the two fold hinges. PLA works if you make the first folds slowly. Warming the hinge with a hair dryer helps.
- **Settings:** 0.4 mm nozzle, 0.2 mm layers (the hinges are the first two layers, 0.4 mm), 100% infill, Arachne / variable line width. Turn on **ironing** for the top surface, because that becomes the outside of the envelope.
- **Gold lettering:** with an AMS / MMU, load both STLs as one object and assign gold to the inlay. On a one-colour printer, skip the inlay and rub gold wax (for example Rub 'n Buff) into the lettering and over the raised seal.

## Folding
1. Tuck the corners of the paper details card into the four slits on the bottom panel.
2. Fold the **bottom panel up** over the middle panel.
3. Fold the **top flap down** over it. Hold it shut with a small removable glue dot under the seal.

Once closed, the tips of the details card show in the bottom corners of the envelope front.
It's a nice touch if the card is a colour (blush or terracotta).

## Mailing
It's rigid and a little under 4 mm thick when closed, so in the US it needs the non-machinable surcharge.
You can also put it inside a 7 × 4 in outer envelope or a padded mailer.

Fonts: Great Vibes and Cinzel (SIL Open Font License, Google Fonts).
