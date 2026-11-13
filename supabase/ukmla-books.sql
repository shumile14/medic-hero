-- Adds the UKMLA Mnemonics e-books to the site's bookshelf: the bundle and the 13 booklets.
-- Run this once in the Supabase SQL editor. Each book shows as "coming soon" until you paste
-- its Payhip link into the "Buy link" box in the admin's E-books tab.
-- Do not upload the paid PDFs to the site: the media bucket is public. The files live on Payhip.
insert into public.books (title, blurb, price, genre, sort) values
  ('UKMLA Mnemonics: the complete set (all 13)', 'All thirteen booklets in one download: 861 memory aids plus the examination routines. Saves £31 on buying them one by one.', '£99', 'medicine', 1),
  ('UKMLA Mnemonics 1 · Medicine Part 1', 'Heart, lungs, gut, liver, kidneys and hormones. 165 memory aids, 89 pages.', '£10', 'medicine', 2),
  ('UKMLA Mnemonics 2 · Medicine Part 2', 'Brain and nerves, blood, cancer, infection, joints and older people. 128 memory aids, 65 pages.', '£10', 'episode', 3),
  ('UKMLA Mnemonics 3 · Surgery', 'The abdomen, perioperative care and anaesthetics, vascular, urology, breast and orthopaedics. 81 memory aids.', '£10', 'business', 4),
  ('UKMLA Mnemonics 4 · Obstetrics and Gynaecology', 'Pregnancy, labour, early pregnancy, gynaecology, sexual health and contraception. 77 memory aids.', '£10', 'unique', 5),
  ('UKMLA Mnemonics 5 · Paediatrics', 'Newborns, breathing and hearts, infection, fluids and kidneys, development and genetics. 78 memory aids.', '£10', 'travel', 6),
  ('UKMLA Mnemonics 6 · Psychiatry', 'Assessment and the law, mood, anxiety, psychosis, eating, substances and neurodevelopment. 58 memory aids.', '£10', 'fragrance', 7),
  ('UKMLA Mnemonics 7 · Ear, Nose and Throat', 'Ears and balance, nose and throat, and lumps in the neck. 31 memory aids.', '£10', 'reviews', 8),
  ('UKMLA Mnemonics 8 · Ophthalmology', 'The red eye, loss of vision, and fields, pupils and eye movements. 38 memory aids.', '£10', 'languages', 9),
  ('UKMLA Mnemonics 9 · Dermatology', 'Rashes, infections and drug reactions, lumps, skin cancers, burns and ulcers. 41 memory aids.', '£10', 'art', 10),
  ('UKMLA Mnemonics 10 · Emergency and Prescribing', 'Resuscitation, the acute take, poisoning and safe prescribing. 83 memory aids.', '£10', 'videography', 11),
  ('UKMLA Mnemonics 11 · Presentations', 'Differential diagnosis mnemonics for the symptoms patients walk in with. 40 memory aids.', '£10', 'magic', 12),
  ('UKMLA Mnemonics 12 · Interpretation', 'ECGs, chest X-rays, blood gases, blood tests, urine and body fluids, with drawn examples. 41 memory aids.', '£10', 'photography', 13),
  ('UKMLA Mnemonics 13 · Examination and Signs', 'Step-by-step bedside examination routines for the CPSA, then the signs to find. 65 memory aids.', '£10', 'medicine', 14);
