#!/bin/sh

#         Original Hash   ->    v1.6 Hash
echo -n "25f3c584290598e2 ->   <UNCHANGED>    (Skill branches)    - "; diff -u 25f3c584290598e2-vs_replace.txt $1-vs_replace.txt | wc -l
echo -n "44b96aae630a0e4b ->   <UNCHANGED>    (Nudle Maps Cloud)  - "; diff -u 44b96aae630a0e4b-vs_replace.txt $1-vs_replace.txt | wc -l
echo -n "54b49e90af66455f -> 3f32030fefac3e92 (3D HUD Text)       - "; diff -u 54b49e90af66455f-vs_replace.txt $1-vs_replace.txt | wc -l
echo -n "55e92f2e53ec4e9e -> ec9112ad05c301c5 (Driver)            - "; diff -u 55e92f2e53ec4e9e-vs_replace.txt $1-vs_replace.txt | wc -l
echo -n "5644294b409cb14e ->   <UNCHANGED>    (Botnet stencil)    - "; diff -u 5644294b409cb14e-vs_replace.txt $1-vs_replace.txt | wc -l
echo -n "720bcc7de9e910ae ->   <UNCHANGED>    (Minimap to screen) - "; diff -u 720bcc7de9e910ae-vs_replace.txt $1-vs_replace.txt | wc -l
echo -n "7729199a02dd9597 -> e657a6685f293348 (ScoutX photo clip) - "; diff -u 7729199a02dd9597-vs_replace.txt $1-vs_replace.txt | wc -l
echo -n "9300b7742d98075d ->   <UNCHANGED>    (Minimap lines)     - "; diff -u 9300b7742d98075d-vs_replace.txt $1-vs_replace.txt | wc -l
echo -n "bccff925fa06f356 -> 2e6ab1fab535c0d4 (3D HUD Text back)  - "; diff -u bccff925fa06f356-vs_replace.txt $1-vs_replace.txt | wc -l
echo -n "be155d5ee051f06f ->   <UNCHANGED?>   (Loading screen)    - "; diff -u be155d5ee051f06f-vs_replace.txt $1-vs_replace.txt | wc -l
echo -n "cb201412f37b67f1 ->   <UNCHANGED>    (Skill menu circle) - "; diff -u cb201412f37b67f1-vs_replace.txt $1-vs_replace.txt | wc -l
echo -n "d103f2f8dce0ba2c -> 24cbb19a8413efe3 (3D HUD)            - "; diff -u d103f2f8dce0ba2c-vs_replace.txt $1-vs_replace.txt | wc -l
echo -n "d9de743384e09702 ->   <UNCHANGED>    (Minimap fill)      - "; diff -u d9de743384e09702-vs_replace.txt $1-vs_replace.txt | wc -l
echo -n "da7596f94f57697e ->   <UNCHANGED>    (2D Menu Text)      - "; diff -u da7596f94f57697e-vs_replace.txt $1-vs_replace.txt | wc -l
echo -n "f04ddad1f29f69a9 ->   <UNCHANGED>    (*Multiple*)        - "; diff -u f04ddad1f29f69a9-vs_replace.txt $1-vs_replace.txt | wc -l
echo -n "ff32b00d4e1880db -> 672f178094b0a9de (Targetting lines)  - "; diff -u ff32b00d4e1880db-vs.txt ../ShaderCache/$1-vs.txt | wc -l

echo "CHECKME: Original 48e2b02145b7383b not in ShaderFixes (d3dx.ini clause only?)"
