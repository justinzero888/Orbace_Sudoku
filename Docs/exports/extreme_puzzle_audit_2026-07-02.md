# Extreme Challenge Puzzle Audit

Date: 2026-07-02

## Source

- Manifest pack id: `extreme`
- Manifest title: `Expert Challenge`
- Manifest difficultyBand: `expert`
- Assets:
  - `assets/puzzles/extreme/extreme_01.json`
  - `assets/puzzles/extreme/extreme_02.json`
  - `assets/puzzles/extreme/extreme_03.json`
  - `assets/puzzles/extreme/extreme_04.json`
  - `assets/puzzles/extreme/extreme_05.json`

## Summary

- Re-rated difficulty counts: {hard: 5, medium: 168, easy: 97}; score range: 100-195; average score: 137.8; advanced-technique puzzles: 270/270.
- Integrity failures: 0
- Difficulty classification mismatches: 540
- Current app logic does not produce `SudokuDifficulty.extreme`; the difficulty rater only maps scores above 240 to `expert`.
- Therefore the current Extreme Challenge pack is better described as Expert/advanced-technique content, not true Extreme content.

## Puzzles

| ID | Clues | Stored | Re-rated | Score | Steps | Techniques | 81-cell givens | Why currently considered hard/expert |
| --- | ---: | --- | --- | ---: | ---: | --- | --- | --- |
| extreme_156 | 27 | expert | hard | 195 | 64 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `008000609020009000000381000000030018800000000090008405050600080061802000200594000` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as hard with score 195, and the rater has no Extreme output band. |
| extreme_175 | 27 | expert | hard | 190 | 62 | hidden_single, naked_pair, naked_single, pointing_pair | `307000080040003900090460000709000060005007204100800300000029000410030700070000003` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as hard with score 190, and the rater has no Extreme output band. |
| extreme_103 | 27 | expert | hard | 187 | 61 | hidden_single, naked_pair, naked_single, pointing_pair | `001076009000500000006000020000789000000000062000003907067800200500030096302090400` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as hard with score 187, and the rater has no Extreme output band. |
| extreme_240 | 26 | expert | hard | 184 | 62 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `043000208060000100000806009700000004000082000030050807006040000107009003300008090` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as hard with score 184, and the rater has no Extreme output band. |
| extreme_136 | 27 | expert | hard | 181 | 60 | hidden_pair, hidden_single, naked_single, pointing_pair | `000000070006020408230080000070000004465090080008000700004000830780005096600300000` | Considered hard/expert because it requires hidden_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as hard with score 181, and the rater has no Extreme output band. |
| extreme_195 | 26 | expert | medium | 180 | 63 | hidden_pair, hidden_single, naked_pair, naked_single | `618002700090000000000500800084203600000900010076000000000706280760004000000095000` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 180, and the rater has no Extreme output band. |
| extreme_212 | 26 | expert | medium | 180 | 62 | hidden_single, naked_pair, naked_single, pointing_pair | `108095060000010000940000008007020480080067000030009000000000004000050372000184000` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 180, and the rater has no Extreme output band. |
| extreme_201 | 26 | expert | medium | 174 | 60 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `000400100004051700109000006005074000003000201000502000000000000321000500590120070` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 174, and the rater has no Extreme output band. |
| extreme_217 | 26 | expert | medium | 174 | 61 | hidden_pair, hidden_single, naked_single, pointing_pair | `020709000107000602300002010000007000040300090078150306700900000010000200000008040` | Considered hard/expert because it requires hidden_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 174, and the rater has no Extreme output band. |
| extreme_145 | 27 | expert | medium | 171 | 60 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `290003000000000713000805000020061000000430009000000600960314800130500000002600004` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 171, and the rater has no Extreme output band. |
| extreme_148 | 27 | expert | medium | 171 | 60 | hidden_single, naked_pair, naked_single, pointing_pair | `020600007030074010070005800403097000507000006800400000000001074000200000081700900` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 171, and the rater has no Extreme output band. |
| extreme_135 | 27 | expert | medium | 170 | 60 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `703610008000090160000000907200100500600000000071000092100060279400009000020500000` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 170, and the rater has no Extreme output band. |
| extreme_138 | 27 | expert | medium | 170 | 60 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `004800000000730601080950000060000008430600007007040100010200000846090003000080005` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 170, and the rater has no Extreme output band. |
| extreme_151 | 27 | expert | medium | 168 | 60 | hidden_single, naked_pair, naked_single, pointing_pair | `020010000875000049000005000032000000007300600600847003003020080040070216060000000` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 168, and the rater has no Extreme output band. |
| extreme_123 | 27 | expert | medium | 167 | 59 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `004950300000713200000400050020800005700100000060030420043008000000000000506300092` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 167, and the rater has no Extreme output band. |
| extreme_064 | 28 | expert | medium | 166 | 58 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `050000900002003010800100000603001000010074000000008020700300850500000439394080002` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 166, and the rater has no Extreme output band. |
| extreme_216 | 26 | expert | medium | 166 | 60 | hidden_single, naked_pair, naked_single, pointing_pair | `005020010700400006000060070030040000001806000247100800500003000076004008000900007` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 166, and the rater has no Extreme output band. |
| extreme_251 | 26 | expert | medium | 166 | 61 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `070000106100000890094300000000078060700000052901500000419000000000040020600007009` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 166, and the rater has no Extreme output band. |
| extreme_208 | 26 | expert | medium | 165 | 62 | hidden_single, naked_pair, naked_single | `000000964040000000801000005100006300060200008003040500010070030090302000008401700` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 165, and the rater has no Extreme output band. |
| extreme_269 | 26 | expert | medium | 164 | 59 | hidden_pair, hidden_single, naked_single, pointing_pair | `800060002000400000040087090400000900020001008000090071365000700000630010009004060` | Considered hard/expert because it requires hidden_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 164, and the rater has no Extreme output band. |
| extreme_040 | 28 | expert | medium | 163 | 58 | hidden_pair, hidden_single, naked_pair, naked_single | `001000945900200700003040600010372000000000060840160200000000009072003050000004120` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 163, and the rater has no Extreme output band. |
| extreme_045 | 28 | expert | medium | 163 | 58 | hidden_pair, hidden_single, naked_pair, naked_single | `025000003678019200010020000000006002100000807050004060530800009007000008002060010` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 163, and the rater has no Extreme output band. |
| extreme_178 | 27 | expert | medium | 163 | 58 | hidden_single, naked_single, pointing_pair | `800070346034000005000306900200000100040069000900002050089004630000030007060000000` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 163, and the rater has no Extreme output band. |
| extreme_213 | 26 | expert | medium | 163 | 60 | hidden_pair, hidden_single, naked_pair, naked_single | `000700030021000900590000000802000300000903000100286500000640100000090020005308700` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 163, and the rater has no Extreme output band. |
| extreme_256 | 26 | expert | medium | 162 | 60 | hidden_pair, hidden_single, naked_pair, naked_single | `060000000500900120409060003057000000000009000200318000090000050085000302001507009` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 162, and the rater has no Extreme output band. |
| extreme_081 | 28 | expert | medium | 160 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `047050600320700001500002080050100260000000000600470003003000000270509010400300007` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 160, and the rater has no Extreme output band. |
| extreme_006 | 27 | expert | medium | 159 | 58 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `040300000000040020200060089002000910075001002000000740950103000080020094700400000` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 159, and the rater has no Extreme output band. |
| extreme_158 | 27 | expert | medium | 159 | 58 | hidden_pair, hidden_single, naked_pair, naked_single | `000070390600100000000369080000000801300806005000400070000200750410090030907000010` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 159, and the rater has no Extreme output band. |
| extreme_235 | 26 | expert | medium | 159 | 60 | hidden_single, naked_pair, naked_single, pointing_pair | `000900000800000007023001900000204000010700600987650000090000524200000800630500000` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 159, and the rater has no Extreme output band. |
| extreme_073 | 28 | expert | medium | 155 | 58 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `200010900001000026804702001005300807600000000000800015748000000010400002000009470` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 155, and the rater has no Extreme output band. |
| extreme_095 | 28 | expert | medium | 155 | 57 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `000007500360080002050040600030076000700000309145000000000108000608050703020000068` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 155, and the rater has no Extreme output band. |
| extreme_255 | 26 | expert | medium | 155 | 60 | hidden_single, naked_pair, naked_single, pointing_pair | `000075080813000270000300000690000410000400700100700002300000000000100604080630090` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 155, and the rater has no Extreme output band. |
| extreme_034 | 28 | expert | medium | 154 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `604800001009050400175000000891000003700020190000008050000009305060200009007600000` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 154, and the rater has no Extreme output band. |
| extreme_129 | 27 | expert | medium | 154 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `093700010016400000700000390002610050070000000300000100100000002000008569065003700` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 154, and the rater has no Extreme output band. |
| extreme_227 | 28 | expert | medium | 154 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `050360000100400800000050103729003000000900005005010700570000040001000000630109502` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 154, and the rater has no Extreme output band. |
| extreme_074 | 28 | expert | medium | 153 | 57 | hidden_pair, hidden_single, naked_pair, naked_single | `805600000070201400000000709003840000428005600700000200500009340034008010000020000` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 153, and the rater has no Extreme output band. |
| extreme_172 | 27 | expert | medium | 153 | 59 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `000009008006070010000130509650000080000003000030260400040000030000300954000590801` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 153, and the rater has no Extreme output band. |
| extreme_180 | 27 | expert | medium | 153 | 57 | hidden_single, naked_single, pointing_pair | `060040700080000002010609004530060400400010006070900030003500009000001000607090040` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 153, and the rater has no Extreme output band. |
| extreme_187 | 26 | expert | medium | 153 | 59 | hidden_pair, hidden_single, naked_pair, naked_single | `010050000800040207070098340080060000430005070500800000003900600002000000040001020` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 153, and the rater has no Extreme output band. |
| extreme_250 | 26 | expert | medium | 153 | 59 | hidden_single, naked_pair, naked_single | `900500824000760000100004009500000900043007000000600400000900013001478000059000000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 153, and the rater has no Extreme output band. |
| extreme_191 | 26 | expert | medium | 152 | 60 | hidden_single, naked_pair, naked_single | `090000068001390700000600200000900300500814092000070000000200000008030510000005026` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 152, and the rater has no Extreme output band. |
| extreme_192 | 26 | expert | medium | 152 | 58 | hidden_single, naked_pair, naked_single | `040080051600501003007000000000000005503800102070000600000020007000350060000609208` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 152, and the rater has no Extreme output band. |
| extreme_209 | 26 | expert | medium | 152 | 59 | hidden_single, naked_pair, naked_single, pointing_pair | `640000000000000209072000140304006000000080050000005701709002000036700528000003000` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 152, and the rater has no Extreme output band. |
| extreme_237 | 26 | expert | medium | 152 | 58 | hidden_pair, hidden_single, naked_pair, naked_single | `000095780037000020200000000940002000703008090001050000500009000078000030002007450` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 152, and the rater has no Extreme output band. |
| extreme_017 | 29 | expert | medium | 151 | 56 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `004000002080000650050200003600020034000001009000438100160500200042160000597000000` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 151, and the rater has no Extreme output band. |
| extreme_234 | 26 | expert | medium | 151 | 58 | hidden_single, naked_pair, naked_single, pointing_pair | `070050000800010050290008007040200000003400192009005000000107005008000701000000340` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 151, and the rater has no Extreme output band. |
| extreme_038 | 28 | expert | medium | 150 | 57 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `001000034004068090000037800200604080009020000000001500468200300090000040530800000` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 150, and the rater has no Extreme output band. |
| extreme_210 | 26 | expert | medium | 150 | 58 | hidden_pair, hidden_single, naked_pair, naked_single | `100002070746003000000004005004500082810000000000000964000000001000498030300005800` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 150, and the rater has no Extreme output band. |
| extreme_219 | 26 | expert | medium | 150 | 58 | hidden_single, naked_pair, naked_single | `000000400598300000300020900730290004210000000000000109070000000003600200920008701` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 150, and the rater has no Extreme output band. |
| extreme_030 | 28 | expert | medium | 149 | 57 | hidden_single, naked_pair, naked_single | `807002013020000006500780000010030000378060000004501000000310060080000000006295100` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 149, and the rater has no Extreme output band. |
| extreme_058 | 28 | expert | medium | 149 | 56 | hidden_single, naked_pair, naked_single, pointing_pair | `500040100040300020103600000054700000000009087380000900000090030700100060031504700` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 149, and the rater has no Extreme output band. |
| extreme_087 | 28 | expert | medium | 149 | 57 | hidden_pair, hidden_single, naked_pair, naked_single | `000100003600000150050030078000000089580000700730090001004806200800009000005000867` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 149, and the rater has no Extreme output band. |
| extreme_220 | 26 | expert | medium | 149 | 59 | hidden_pair, hidden_single, naked_pair, naked_single | `000000001007264900003000260048000090000090407300080500000700040060000009000048052` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 149, and the rater has no Extreme output band. |
| extreme_260 | 26 | expert | medium | 149 | 59 | hidden_single, naked_pair, naked_single | `000500670005060903060002000000900200070003000020610049000009001030700400040008060` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 149, and the rater has no Extreme output band. |
| extreme_089 | 28 | expert | medium | 148 | 57 | hidden_single, naked_pair, naked_single | `800265000000000008047003000200001809000508072050020030010804000004009007500002080` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 148, and the rater has no Extreme output band. |
| extreme_161 | 27 | expert | medium | 148 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `007080000100300590000010030280000300716000082000000600370090000050208170000001009` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 148, and the rater has no Extreme output band. |
| extreme_173 | 27 | expert | medium | 148 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `670100080080000005005003670000008010000500309507040060006000004004750030900020000` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 148, and the rater has no Extreme output band. |
| extreme_229 | 26 | expert | medium | 148 | 57 | hidden_single, naked_pair, naked_single | `004100052000000001300007400632000040400002000008901000000600080009400000200009314` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 148, and the rater has no Extreme output band. |
| extreme_238 | 26 | expert | medium | 148 | 56 | hidden_single, naked_pair, naked_single | `740509300100000080306004000000900501070000040000060000050000018001320400400100005` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 148, and the rater has no Extreme output band. |
| extreme_231 | 26 | expert | medium | 147 | 57 | hidden_pair, hidden_single, naked_pair, naked_single | `905300671000020000300007000032800009004000503000502000109003000000050230280000000` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 147, and the rater has no Extreme output band. |
| extreme_023 | 29 | expert | medium | 146 | 55 | hidden_single, naked_single, pointing_pair | `306000145000100030005000700000450300000060091007290058060010003104503000803000000` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 146, and the rater has no Extreme output band. |
| extreme_078 | 27 | expert | medium | 146 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `008200700000010500470000900030192480000000005040600000003000804002540600080000072` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 146, and the rater has no Extreme output band. |
| extreme_137 | 27 | expert | medium | 146 | 58 | hidden_pair, hidden_single, naked_pair, naked_single | `068900004700000020005000060000800000070410006090007401000600000040108609050074080` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 146, and the rater has no Extreme output band. |
| extreme_186 | 27 | expert | medium | 146 | 57 | hidden_pair, hidden_single, naked_pair, naked_single | `804900000007365000000000027500000048040090003060200070695000700001008005700009000` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 146, and the rater has no Extreme output band. |
| extreme_190 | 26 | expert | medium | 146 | 57 | hidden_pair, hidden_single, naked_single, pointing_pair | `000710000061080000940000060450201000007008300000430000070000038100000270804000001` | Considered hard/expert because it requires hidden_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 146, and the rater has no Extreme output band. |
| extreme_197 | 26 | expert | medium | 145 | 57 | hidden_single, naked_single, pointing_pair | `004091002001200008000050900546002000010070060000000009000023807100000000705060030` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 145, and the rater has no Extreme output band. |
| extreme_223 | 26 | expert | medium | 145 | 56 | hidden_single, naked_pair, naked_single | `540900000002000000001400028000209006025080000010000059700540890100067500000000000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 145, and the rater has no Extreme output band. |
| extreme_047 | 28 | expert | medium | 144 | 56 | hidden_single, naked_pair, naked_single | `700005600002630900000080005300408000070013060006700000080070000127056040000000201` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 144, and the rater has no Extreme output band. |
| extreme_097 | 28 | expert | medium | 144 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `000980000407200090800007600640009507000000913010000040070000000961300000038020100` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 144, and the rater has no Extreme output band. |
| extreme_099 | 28 | expert | medium | 144 | 56 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `000003209259040300380000760030050000000761030006009400010000002003000800600100090` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 144, and the rater has no Extreme output band. |
| extreme_143 | 27 | expert | medium | 144 | 57 | hidden_single, naked_pair, naked_single | `910800065600009308000000100000290000092100080400060050050000000000001006087650020` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 144, and the rater has no Extreme output band. |
| extreme_152 | 27 | expert | medium | 144 | 57 | hidden_single, naked_pair, naked_single | `000070005600230040708000020001052000900000030000794001000000007007800103100900480` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 144, and the rater has no Extreme output band. |
| extreme_266 | 26 | expert | medium | 144 | 57 | hidden_single, naked_pair, naked_single | `320806000000000050650000021800900100000530069700200030000009000270300006000000013` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 144, and the rater has no Extreme output band. |
| extreme_050 | 28 | expert | medium | 143 | 56 | hidden_single, naked_pair, naked_single | `362090001400000050970800000003900002100305700000010600200650004006000000840100009` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 143, and the rater has no Extreme output band. |
| extreme_057 | 28 | expert | medium | 143 | 56 | hidden_pair, hidden_single, naked_pair, naked_single | `087060025200000900000300008572009600000050400800000207745006000000500000900100074` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 143, and the rater has no Extreme output band. |
| extreme_069 | 28 | expert | medium | 143 | 55 | hidden_pair, hidden_single, naked_pair, naked_single | `000000000006745008090030574000800605560090000008300740600573000700000010040000300` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 143, and the rater has no Extreme output band. |
| extreme_109 | 27 | expert | medium | 143 | 57 | hidden_pair, hidden_single, naked_pair, naked_single | `040005000900340000005027300002080000501002600680500003003400007000060000058009200` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 143, and the rater has no Extreme output band. |
| extreme_111 | 27 | expert | medium | 143 | 57 | hidden_pair, hidden_single, naked_pair, naked_single | `900000006701049000000000890000301000006050300170008000080900501000786002400510000` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 143, and the rater has no Extreme output band. |
| extreme_182 | 27 | expert | medium | 143 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `008000653000000017200005000009030000800070321020000040100200000080407000002698070` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 143, and the rater has no Extreme output band. |
| extreme_083 | 28 | expert | medium | 142 | 57 | hidden_single, naked_pair, naked_single | `400020700300000090200507860150376000804000000000000500928100400040800300500060000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 142, and the rater has no Extreme output band. |
| extreme_163 | 27 | expert | medium | 142 | 56 | hidden_pair, hidden_single, naked_pair, naked_single | `008000047009800050050007063800500009924000000000400070000305210400000000000014790` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 142, and the rater has no Extreme output band. |
| extreme_205 | 26 | expert | medium | 142 | 58 | hidden_single, naked_pair, naked_single | `180000043003001000000600002200000000308070500006403007004308000020900001801007000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 142, and the rater has no Extreme output band. |
| extreme_262 | 26 | expert | medium | 142 | 56 | hidden_single, naked_pair, naked_single | `043908000005037900090000007000079081160000070000000500501040706600810000000000000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 142, and the rater has no Extreme output band. |
| extreme_029 | 28 | expert | medium | 141 | 55 | hidden_single, naked_pair, naked_single | `020010060810000500609000000900000346060000108501003200307050010000006000100090025` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 141, and the rater has no Extreme output band. |
| extreme_146 | 27 | expert | medium | 141 | 57 | hidden_single, naked_pair, naked_single | `600028900000001503007006000000084005710260800000000000070000001900600308208000056` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 141, and the rater has no Extreme output band. |
| extreme_154 | 27 | expert | medium | 141 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `000900003043076000100030000008000000200683009010002000801050006000018020920304000` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 141, and the rater has no Extreme output band. |
| extreme_202 | 26 | expert | medium | 141 | 56 | hidden_single, naked_single, pointing_pair | `900000000037000000002008750200085300003240000008700029010007030000090080805002000` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 141, and the rater has no Extreme output band. |
| extreme_249 | 26 | expert | medium | 141 | 56 | hidden_single, naked_pair, naked_single | `040570000027010030080004000400260000206001000803000700030000078000000000002706310` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 141, and the rater has no Extreme output band. |
| extreme_270 | 26 | expert | medium | 141 | 57 | hidden_single, naked_pair, naked_single | `070000000201080000940005006008900500502073010010000000120000090000400600600700024` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 141, and the rater has no Extreme output band. |
| extreme_075 | 28 | expert | medium | 140 | 56 | hidden_pair, hidden_single, naked_pair, naked_single | `003017900000000020090632001005309067010050390000000000306501200008000006400000500` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 140, and the rater has no Extreme output band. |
| extreme_094 | 28 | expert | medium | 140 | 56 | hidden_single, naked_pair, naked_single | `900030080000609200207004901800000052603000800000040600080203007000070090500080020` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 140, and the rater has no Extreme output band. |
| extreme_127 | 27 | expert | medium | 140 | 56 | hidden_single, naked_single, pointing_pair | `002001304008002000970000025009420060500080030000510008000000150004000003190800000` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 140, and the rater has no Extreme output band. |
| extreme_142 | 27 | expert | medium | 140 | 56 | hidden_single, naked_pair, naked_single, pointing_pair | `400090000059060073000000150040001308028070010600000000061703504002000000500000030` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 140, and the rater has no Extreme output band. |
| extreme_252 | 26 | expert | medium | 140 | 57 | hidden_single, naked_pair, naked_single | `001789020000000000540301008000006003000930007908000100000000031625010000800000600` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 140, and the rater has no Extreme output band. |
| extreme_005 | 32 | expert | medium | 139 | 53 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `500000800000846000640020900903000000854017000700000405006004000470092038200083540` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 139, and the rater has no Extreme output band. |
| extreme_021 | 29 | expert | medium | 139 | 55 | hidden_single, naked_pair, naked_single | `010002350503070600006309001000023508085000400200090006000030000870000200050900004` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 139, and the rater has no Extreme output band. |
| extreme_076 | 28 | expert | medium | 139 | 56 | hidden_pair, hidden_single, naked_single, pointing_pair | `200080109007509240150020800000800304010076000000000000000008490090002000578000030` | Considered hard/expert because it requires hidden_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 139, and the rater has no Extreme output band. |
| extreme_100 | 28 | expert | medium | 139 | 55 | hidden_pair, hidden_single, naked_pair, naked_single | `500000000000060003038901060790600840800000000001042000060058020070106450000000106` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 139, and the rater has no Extreme output band. |
| extreme_104 | 27 | expert | medium | 139 | 56 | hidden_single, naked_pair, naked_single, pointing_pair | `630720000005300280070100000000001900000267015008003002000010000400602000003005009` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 139, and the rater has no Extreme output band. |
| extreme_130 | 27 | expert | medium | 139 | 56 | hidden_single, naked_pair, naked_single, pointing_pair | `000020010800000700040096800000000097170000340050109000017008203000007000008230400` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 139, and the rater has no Extreme output band. |
| extreme_170 | 27 | expert | medium | 139 | 57 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `007050000054060710002100090000001000000008034000520807490000071006093000200006000` | Considered hard/expert because it requires hidden_pair, naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 139, and the rater has no Extreme output band. |
| extreme_244 | 26 | expert | medium | 139 | 57 | hidden_single, naked_pair, naked_single | `500100000009205010000006800080400602300000000006000740001039068000600000000500379` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 139, and the rater has no Extreme output band. |
| extreme_088 | 28 | expert | medium | 138 | 56 | hidden_single, naked_pair, naked_single | `000000080000390570576004000000700100040001309008953000002009010000400832700030000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 138, and the rater has no Extreme output band. |
| extreme_166 | 27 | expert | medium | 138 | 56 | hidden_single, naked_pair, naked_single | `500008206000000140408026900300000509000341082000000000060000000087060094000107000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 138, and the rater has no Extreme output band. |
| extreme_174 | 27 | expert | medium | 138 | 56 | hidden_single, naked_pair, naked_single | `100400658200000003005000090002060300001000007806903005000000000000600780564080002` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 138, and the rater has no Extreme output band. |
| extreme_189 | 26 | expert | medium | 138 | 58 | hidden_single, naked_pair, naked_single | `060070500000430080000001040000600097079000803000020000005000100100000038080010654` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 138, and the rater has no Extreme output band. |
| extreme_211 | 26 | expert | medium | 138 | 57 | hidden_pair, hidden_single, naked_pair, naked_single | `000000500100000076768000209000037095000200000000000460570000080019080300000050901` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 138, and the rater has no Extreme output band. |
| extreme_253 | 26 | expert | medium | 138 | 57 | hidden_pair, hidden_single, naked_pair, naked_single | `000600080020003000009001624508046030000000040000200005090050007700402000050100400` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 138, and the rater has no Extreme output band. |
| extreme_035 | 28 | expert | medium | 137 | 55 | hidden_single, naked_pair, naked_single | `000700450007400002650012700536070000009630001000000000300100004000000520400020190` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 137, and the rater has no Extreme output band. |
| extreme_059 | 28 | expert | medium | 137 | 55 | hidden_pair, hidden_single, naked_single, pointing_pair | `000002047000096200100040000020900800308020750000360004200500900000080400010079002` | Considered hard/expert because it requires hidden_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 137, and the rater has no Extreme output band. |
| extreme_085 | 28 | expert | medium | 137 | 55 | hidden_single, naked_pair, naked_single | `005308000000500082820004009089003007000000200040001950200750090030400000000039400` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 137, and the rater has no Extreme output band. |
| extreme_214 | 26 | expert | medium | 137 | 57 | hidden_single, naked_pair, naked_single | `064700005031000480000060000300000062510008000008007050100290000200003507000000600` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 137, and the rater has no Extreme output band. |
| extreme_254 | 26 | expert | medium | 137 | 56 | hidden_single, naked_pair, naked_single | `000057390200800000500000010000098500000010230105000000427906000851000000009080000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 137, and the rater has no Extreme output band. |
| extreme_013 | 29 | expert | medium | 136 | 53 | hidden_pair, hidden_single, naked_single | `006000501050026030080540000900000400030005090600000308800150074010600000704002003` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as medium with score 136, and the rater has no Extreme output band. |
| extreme_052 | 28 | expert | medium | 136 | 55 | hidden_single, naked_pair, naked_single | `003000015500000000879500300080900040041082000007001083005000800000298000200700030` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 136, and the rater has no Extreme output band. |
| extreme_053 | 28 | expert | medium | 136 | 55 | hidden_pair, hidden_single, naked_pair, naked_single | `007050100040103090000000408004000000021930070090570001482009000009065000000800300` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 136, and the rater has no Extreme output band. |
| extreme_184 | 27 | expert | medium | 136 | 56 | hidden_pair, hidden_single, naked_single | `000000407070526080000097006001000003800004270200000900000130000190742000020000030` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as medium with score 136, and the rater has no Extreme output band. |
| extreme_204 | 26 | expert | medium | 136 | 56 | hidden_single, naked_pair, naked_single | `090803057030000004007000080005000700008900000060180090000092070000010069020700500` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 136, and the rater has no Extreme output band. |
| extreme_215 | 26 | expert | medium | 136 | 56 | hidden_single, naked_pair, naked_single | `100002540000000310006030000010005060000009000285000100000360790301000250900004000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 136, and the rater has no Extreme output band. |
| extreme_230 | 26 | expert | medium | 136 | 56 | hidden_single, naked_pair, naked_single | `400000075000000600700260800657400000000050204800001060500000000000100720076800900` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 136, and the rater has no Extreme output band. |
| extreme_268 | 26 | expert | medium | 136 | 57 | hidden_pair, hidden_single, naked_single | `090710068000000500001680000840000000200136000000890005020000004016308000300000050` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as medium with score 136, and the rater has no Extreme output band. |
| extreme_048 | 28 | expert | medium | 135 | 55 | hidden_single, naked_pair, naked_single, pointing_pair | `020100000107030000903800401006308000000069823080000007000210004001097006000000500` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 135, and the rater has no Extreme output band. |
| extreme_072 | 28 | expert | medium | 135 | 55 | hidden_pair, hidden_single, naked_single | `008000071000200600050000800760010200080706100090500000907000026005900310013000009` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as medium with score 135, and the rater has no Extreme output band. |
| extreme_155 | 27 | expert | medium | 135 | 56 | hidden_single, naked_pair, naked_single | `008000090070009000950000247360400700200600084001070000730000000020000658006040000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 135, and the rater has no Extreme output band. |
| extreme_196 | 26 | expert | medium | 135 | 57 | hidden_single, naked_pair, naked_single | `600007230098200000005046000000539020000001500000000807800000040400300002062000009` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 135, and the rater has no Extreme output band. |
| extreme_198 | 26 | expert | medium | 135 | 57 | hidden_pair, hidden_single, naked_pair, naked_single | `921000800000503900000000000530000687000000000000708590300016008005002060140070000` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 135, and the rater has no Extreme output band. |
| extreme_203 | 26 | expert | medium | 135 | 57 | hidden_single, naked_pair, naked_single | `000030400004508000760000150000189735500020010000000000009051000020800000070000904` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 135, and the rater has no Extreme output band. |
| extreme_259 | 26 | expert | medium | 135 | 56 | hidden_single, naked_pair, naked_single | `800602070000900030263500000706800000009060408000200000001000607030020010600000900` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 135, and the rater has no Extreme output band. |
| extreme_264 | 26 | expert | medium | 135 | 56 | hidden_single, naked_single, pointing_pair | `001200064900010000020600700000954002070000000000020800003000000500000089089470210` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 135, and the rater has no Extreme output band. |
| extreme_043 | 28 | expert | medium | 134 | 54 | hidden_single, naked_pair, naked_single | `000900083050000000130002045001040000506080000380021500400890000005013006000400050` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 134, and the rater has no Extreme output band. |
| extreme_066 | 28 | expert | medium | 134 | 55 | hidden_single, naked_pair, naked_single | `000000000500000937900854001060010098000900050709540003000000019004100800301005000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 134, and the rater has no Extreme output band. |
| extreme_131 | 27 | expert | medium | 134 | 55 | hidden_single, naked_single, pointing_pair | `050478009800000103000500800000004001200300070006000030915000000000000300380620015` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 134, and the rater has no Extreme output band. |
| extreme_159 | 27 | expert | medium | 134 | 56 | hidden_single, naked_pair, naked_single | `015000900007030020609000740000060072000040300500021000094006000100800400000004015` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 134, and the rater has no Extreme output band. |
| extreme_168 | 27 | expert | medium | 134 | 55 | hidden_single, naked_pair, naked_single | `710000800069040700000000069071000980020050000980010300000123000090570002100000000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 134, and the rater has no Extreme output band. |
| extreme_193 | 26 | expert | medium | 134 | 57 | hidden_single, naked_pair, naked_single | `028000090000205007000004500000026831650310000000000000000659000080040005900030100` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 134, and the rater has no Extreme output band. |
| extreme_206 | 26 | expert | medium | 134 | 56 | hidden_single, naked_pair, naked_single | `309060000207000000040009020030900670006004002020000080003070068500081000601000000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 134, and the rater has no Extreme output band. |
| extreme_226 | 26 | expert | medium | 134 | 57 | hidden_single, naked_pair, naked_single | `062000050000080000000000739000800000000009310010450007983000006000027903000098100` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 134, and the rater has no Extreme output band. |
| extreme_233 | 26 | expert | medium | 134 | 57 | hidden_single, naked_pair, naked_single | `860000150000103006000040700400900000013000400000027901000004210600000005000080670` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 134, and the rater has no Extreme output band. |
| extreme_241 | 26 | expert | medium | 134 | 57 | hidden_single, naked_pair, naked_single | `000400563500007080000060200003000090609002800040600002305708040000000001004300000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 134, and the rater has no Extreme output band. |
| extreme_261 | 26 | expert | medium | 134 | 57 | hidden_single, naked_pair, naked_single | `000004001506000000070000932000002050084007003060000200690000870850910000040000010` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 134, and the rater has no Extreme output band. |
| extreme_265 | 26 | expert | medium | 134 | 57 | hidden_single, naked_pair, naked_single | `060000310070000950009071020000500160030000500000036084000050600307004000010000030` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 134, and the rater has no Extreme output band. |
| extreme_033 | 28 | expert | medium | 133 | 55 | hidden_pair, hidden_single, naked_single | `700060200056000007800017500685000401000090000140800000530002600210040000060000070` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as medium with score 133, and the rater has no Extreme output band. |
| extreme_068 | 28 | expert | medium | 133 | 54 | hidden_single, naked_single, pointing_pair | `000009361030020000700000050200040010100005004070000003020050107400970006917000040` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 133, and the rater has no Extreme output band. |
| extreme_096 | 28 | expert | medium | 133 | 55 | hidden_single, naked_pair, naked_single | `009002003063000050000000710300759000005004001020003070107900640000000590000080107` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 133, and the rater has no Extreme output band. |
| extreme_114 | 27 | expert | medium | 133 | 55 | hidden_pair, hidden_single, naked_single | `030200800000310006004007000050080701000004600908000020000050008005008903046903000` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as medium with score 133, and the rater has no Extreme output band. |
| extreme_119 | 27 | expert | medium | 133 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `010040600407053010000890000000938401000500083000007000093080250052000000000000006` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 133, and the rater has no Extreme output band. |
| extreme_026 | 29 | expert | medium | 132 | 53 | hidden_single, naked_pair, naked_single | `500000400830000005600120900460500000200019300001604000090003620000000501020050803` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_046 | 28 | expert | medium | 132 | 55 | hidden_single, naked_pair, naked_single | `060002040802079600000360000700000200018000073504000060180200300006000000200006805` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_067 | 28 | expert | medium | 132 | 55 | hidden_single, naked_pair, naked_single, pointing_pair | `000804312000231600000000000050008020483010700020900400000706500007400000090080060` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_070 | 28 | expert | medium | 132 | 54 | hidden_single, naked_pair, naked_single | `408100520007025000000400030060700305000062047000000000000051009006374050200006000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_084 | 28 | expert | medium | 132 | 54 | hidden_single, naked_pair, naked_single | `510003000004005008080000090007400030000031800193270000200000080000300207008760400` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_101 | 27 | expert | medium | 132 | 55 | hidden_single, naked_pair, naked_single | `020400610093000000001520000030000708706205041000706000850002000000000320000069000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_126 | 27 | expert | medium | 132 | 55 | hidden_single, naked_single, pointing_pair | `020080506100060400000400030652000000019025000000800052300000000060300985080040000` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_147 | 27 | expert | medium | 132 | 55 | hidden_single, naked_pair, naked_single | `005000300000643280030000970000300010102060850080207000008000000004801090060030000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_162 | 27 | expert | medium | 132 | 56 | hidden_single, naked_pair, naked_single | `000304000500690043010005000009050060000000500251006409005739000007000600104000000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_167 | 27 | expert | medium | 132 | 57 | hidden_single, naked_pair, naked_single | `000400500040060030500000901650700100092030000000020650080002067300890200000000080` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_183 | 27 | expert | medium | 132 | 56 | hidden_single, naked_pair, naked_single | `865040100004000000000600009000000810237810000000004000053080097048000500000501400` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_188 | 26 | expert | medium | 132 | 56 | hidden_single, naked_pair, naked_single | `000340085000008020001090300000700006008030750000009000805003000000070060000586902` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_199 | 26 | expert | medium | 132 | 56 | hidden_single, naked_pair, naked_single | `020000085900300000805000107050000700200590008000000019080000902000010040060907050` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_207 | 26 | expert | medium | 132 | 57 | hidden_single, naked_pair, naked_single | `009000710010080000600200009970800003000300070000000540090053006000090000304620800` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_236 | 26 | expert | medium | 132 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `009000300000100000428060000000056900030720605040300070580030200007005060060000000` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_245 | 26 | expert | medium | 132 | 56 | hidden_single, naked_pair, naked_single | `506000000090324005240050001309000070020080090000001000002000004000143007001000800` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_267 | 26 | expert | medium | 132 | 56 | hidden_single, naked_pair, naked_single | `046800050000200460000000108070940000004510000020600809000000023058000004000409000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 132, and the rater has no Extreme output band. |
| extreme_063 | 28 | expert | medium | 131 | 55 | hidden_single, naked_pair, naked_single | `500060070004503020100940500009050281000006005300208000000670490003005000000000800` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 131, and the rater has no Extreme output band. |
| extreme_112 | 27 | expert | medium | 131 | 55 | hidden_single, naked_pair, naked_single | `300076010009000000051200700010000009603001400400000070080403000070000900934600200` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 131, and the rater has no Extreme output band. |
| extreme_132 | 27 | expert | medium | 131 | 56 | hidden_pair, hidden_single, naked_pair, naked_single | `740093600006800000031005070600502000020400300004009080000000900000040001307006200` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 131, and the rater has no Extreme output band. |
| extreme_160 | 27 | expert | medium | 131 | 55 | hidden_single, naked_pair, naked_single | `900841000000570040100030005000060000809410000036000200302000000000904021400100050` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 131, and the rater has no Extreme output band. |
| extreme_169 | 27 | expert | medium | 131 | 55 | hidden_single, naked_pair, naked_single | `200000018010407060000050004000000000306089050001745300005060000030000000602000785` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 131, and the rater has no Extreme output band. |
| extreme_171 | 27 | expert | medium | 131 | 55 | hidden_single, naked_pair, naked_single | `000702054504900003070000000000400000010050480800020075000270038100500000000004207` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 131, and the rater has no Extreme output band. |
| extreme_225 | 26 | expert | medium | 131 | 56 | hidden_single, naked_single, pointing_pair | `328000900600080010010000003005000000830000260900308070087005090000002000290000600` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as medium with score 131, and the rater has no Extreme output band. |
| extreme_248 | 26 | expert | medium | 131 | 57 | hidden_single, naked_pair, naked_single | `314908000006005314000000000008000903000000125120000060600002050087000600000090000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 131, and the rater has no Extreme output band. |
| extreme_258 | 31 | expert | medium | 131 | 52 | hidden_pair, hidden_single, naked_pair, naked_single | `002045700540308020873000400008000304096000080030027000001003002007000843000062000` | Considered hard/expert because it requires hidden_pair, naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 131, and the rater has no Extreme output band. |
| extreme_263 | 26 | expert | medium | 131 | 57 | hidden_single, naked_pair, naked_single | `000000008090402030060070002000507800100040500000890240070000300000026000600709080` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as medium with score 131, and the rater has no Extreme output band. |
| extreme_077 | 28 | expert | easy | 130 | 55 | hidden_single, naked_pair, naked_single, pointing_pair | `000000490235000006004006000900007100050460007000503600823000060510000300000038900` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as easy with score 130, and the rater has no Extreme output band. |
| extreme_082 | 28 | expert | easy | 130 | 54 | hidden_single, naked_pair, naked_single | `520000078000030001040007200280050000030069800010000045302041000800700010054000000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 130, and the rater has no Extreme output band. |
| extreme_090 | 28 | expert | easy | 130 | 54 | hidden_single, naked_pair, naked_single | `900702100000000900030400007000640002700309050406000890309007000200030605000000340` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 130, and the rater has no Extreme output band. |
| extreme_122 | 27 | expert | easy | 130 | 55 | hidden_pair, hidden_single, naked_single | `000030504803700160000600800000009041041000030000010608200570010050004009000000007` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as easy with score 130, and the rater has no Extreme output band. |
| extreme_157 | 27 | expert | easy | 130 | 55 | hidden_single, naked_pair, naked_single | `300900200000053060040200000073000040400001009006824000004032000201000408060009000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 130, and the rater has no Extreme output band. |
| extreme_194 | 26 | expert | easy | 130 | 56 | hidden_single, naked_pair, naked_single | `100800600006143070079200000000000004400000780000052009090000240000700000568004000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 130, and the rater has no Extreme output band. |
| extreme_242 | 26 | expert | easy | 130 | 56 | hidden_single, naked_pair, naked_single | `804000007000004000009730005008002000710000009500908700020040900030000060900006073` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 130, and the rater has no Extreme output band. |
| extreme_243 | 26 | expert | easy | 130 | 56 | hidden_pair, hidden_single, naked_single | `047800010610904805000000000000000301502010060000006590430000008000000000209105000` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as easy with score 130, and the rater has no Extreme output band. |
| extreme_246 | 26 | expert | easy | 130 | 57 | hidden_single, naked_pair, naked_single | `000370450006000000730000208000054060000090000002800510009000070005409800800010600` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 130, and the rater has no Extreme output band. |
| extreme_247 | 26 | expert | easy | 130 | 56 | hidden_single, naked_pair, naked_single | `000270040860030000200000005400000000000008460700460052948610000001000000070000603` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 130, and the rater has no Extreme output band. |
| extreme_018 | 29 | expert | easy | 129 | 53 | hidden_single, naked_pair, naked_single | `002400000900650300480900060000720400000030900504010002000245009000300016008100500` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 129, and the rater has no Extreme output band. |
| extreme_025 | 29 | expert | easy | 129 | 54 | hidden_single, naked_pair, naked_single | `270000900001050008950070601007003060160400023800105000000000386000010000002300500` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 129, and the rater has no Extreme output band. |
| extreme_032 | 28 | expert | easy | 129 | 54 | hidden_single, naked_pair, naked_single | `904520000060000800000017000005762000000800267200001050008000000610400002520090300` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 129, and the rater has no Extreme output band. |
| extreme_039 | 28 | expert | easy | 129 | 55 | hidden_single, naked_pair, naked_single | `030500000845000137000010000061047002008290360000030000589002700000058003000000000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 129, and the rater has no Extreme output band. |
| extreme_105 | 27 | expert | easy | 129 | 55 | hidden_pair, hidden_single, naked_single | `407206010000400500000001700000608000600000259104000080700000000000004927000090635` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as easy with score 129, and the rater has no Extreme output band. |
| extreme_110 | 27 | expert | easy | 129 | 56 | hidden_single, naked_pair, naked_single | `005000200004008060700100000000507030040829000057006800002040900400080050000702001` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 129, and the rater has no Extreme output band. |
| extreme_113 | 27 | expert | easy | 129 | 55 | hidden_single, naked_pair, naked_single | `024705019070000080009000000050004867002000090680500000201007000700003900060000008` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 129, and the rater has no Extreme output band. |
| extreme_125 | 27 | expert | easy | 129 | 55 | hidden_pair, hidden_single, naked_single | `508040000004690000160005020000850640000000000000006791006178000010000006400300800` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as easy with score 129, and the rater has no Extreme output band. |
| extreme_139 | 27 | expert | easy | 129 | 55 | hidden_pair, hidden_single, naked_single | `000008000305000000067040053008070000219000067030020400000400500050090008004000719` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as easy with score 129, and the rater has no Extreme output band. |
| extreme_141 | 27 | expert | easy | 129 | 55 | hidden_single, naked_pair, naked_single | `040009700000820060000601005004006027000000800002018600001000000069030210500002006` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 129, and the rater has no Extreme output band. |
| extreme_144 | 27 | expert | easy | 129 | 55 | hidden_single, naked_pair, naked_single | `000100000103506000000097830900070100000965073000081000705000000030002050000000348` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 129, and the rater has no Extreme output band. |
| extreme_004 | 32 | expert | easy | 128 | 52 | hidden_single, naked_pair, naked_single | `459700300078001049200040000000930004090050106504000902005000093040085000020400080` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 128, and the rater has no Extreme output band. |
| extreme_031 | 28 | expert | easy | 128 | 54 | hidden_single, naked_pair, naked_single | `600000700010840009874000030000010097000003001001906320000034900008500000100089000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 128, and the rater has no Extreme output band. |
| extreme_037 | 28 | expert | easy | 128 | 54 | hidden_single, naked_pair, naked_single | `000100000003450000160000900700300509000985040005000213000008090000600002090001835` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 128, and the rater has no Extreme output band. |
| extreme_079 | 28 | expert | easy | 128 | 54 | hidden_single, naked_pair, naked_single | `540070009000340017070006030007000340050000106004061000000020903000500000030004062` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 128, and the rater has no Extreme output band. |
| extreme_115 | 27 | expert | easy | 128 | 55 | hidden_single, naked_pair, naked_single | `060005900000300080508000601000608070050742000200003500601000340000080007005030000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 128, and the rater has no Extreme output band. |
| extreme_117 | 27 | expert | easy | 128 | 55 | hidden_single, naked_pair, naked_single | `000005000000700019900000874000006003000070050006234000890000700200081000503400098` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 128, and the rater has no Extreme output band. |
| extreme_121 | 27 | expert | easy | 128 | 55 | hidden_single, naked_single, pointing_pair | `907001000008003700030000806003006040000000208860000307100047080089060000004200000` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as easy with score 128, and the rater has no Extreme output band. |
| extreme_128 | 27 | expert | easy | 128 | 55 | hidden_single, naked_pair, naked_single | `036017000000009020080300000305640700000000030001005600050270008720008060008000004` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 128, and the rater has no Extreme output band. |
| extreme_164 | 27 | expert | easy | 128 | 55 | hidden_single, naked_pair, naked_single | `040800001105900006020007040000028007000140380000000190907403000000050010000790000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 128, and the rater has no Extreme output band. |
| extreme_176 | 27 | expert | easy | 128 | 55 | hidden_single, naked_single, pointing_pair | `630100000000008635900000000000000500064817000003006108400001000000040019800602007` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as easy with score 128, and the rater has no Extreme output band. |
| extreme_179 | 27 | expert | easy | 128 | 55 | hidden_single, naked_pair, naked_single | `000403006020008001009500030000000003431200050070100090290000700000090800650700020` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 128, and the rater has no Extreme output band. |
| extreme_185 | 27 | expert | easy | 128 | 56 | hidden_single, naked_pair, naked_single | `000607005020000678008203000040032000083500007100070000031904000000020050000000940` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 128, and the rater has no Extreme output band. |
| extreme_007 | 30 | expert | easy | 127 | 52 | hidden_single, naked_pair, naked_single | `940050007086000900302100060000000000705302800023080706000860005050000689000700100` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 127, and the rater has no Extreme output band. |
| extreme_009 | 30 | expert | easy | 127 | 53 | hidden_single, naked_single, pointing_pair | `000700502070000038206083000000805940104000850005010006010000025000040097060002100` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as easy with score 127, and the rater has no Extreme output band. |
| extreme_028 | 28 | expert | easy | 127 | 54 | hidden_pair, hidden_single, naked_single | `090000240000000030703410009071004560020000007000003490000840005000000120000031980` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as easy with score 127, and the rater has no Extreme output band. |
| extreme_061 | 28 | expert | easy | 127 | 54 | hidden_single, naked_single, pointing_pair | `631004250000000000070500301200095106095700000000000000900050007400002013050067000` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as easy with score 127, and the rater has no Extreme output band. |
| extreme_102 | 27 | expert | easy | 127 | 55 | hidden_single, naked_pair, naked_single | `003700200010040005000082060001036789300000002000400600000060800000004090690200001` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 127, and the rater has no Extreme output band. |
| extreme_124 | 27 | expert | easy | 127 | 55 | hidden_pair, hidden_single, naked_single | `040600150600000000300009870560000207728001300000008000100000908000002000000076034` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as easy with score 127, and the rater has no Extreme output band. |
| extreme_140 | 27 | expert | easy | 127 | 55 | hidden_single, naked_pair, naked_single | `015000000604020090380004001921000000000007002500091003800003000000010029000980004` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 127, and the rater has no Extreme output band. |
| extreme_200 | 26 | expert | easy | 127 | 56 | hidden_single, naked_pair, naked_single | `850009301000000000000600049000090006090510400005007000530800072000900000270000860` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 127, and the rater has no Extreme output band. |
| extreme_218 | 26 | expert | easy | 127 | 56 | hidden_single, naked_pair, naked_single | `910000006000064090000000580300000608090400032000301000608100970042000000000050010` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 127, and the rater has no Extreme output band. |
| extreme_228 | 26 | expert | easy | 127 | 56 | hidden_single, naked_pair, naked_single | `000000600000000087730100005000903100000006072010002800100070900090250030003098000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 127, and the rater has no Extreme output band. |
| extreme_232 | 26 | expert | easy | 127 | 56 | hidden_pair, hidden_single, naked_single | `000050100014000580800009007008006003009020400000001760000097000006000070090030045` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as easy with score 127, and the rater has no Extreme output band. |
| extreme_036 | 28 | expert | easy | 126 | 54 | hidden_single, naked_pair, naked_single | `008932000020000008607005300070600500400009000001020400014000002700401900900006010` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 126, and the rater has no Extreme output band. |
| extreme_041 | 28 | expert | easy | 126 | 54 | hidden_single, naked_pair, naked_single | `003000071000050020710930000370208406004700980000000007000300248000060000900820000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 126, and the rater has no Extreme output band. |
| extreme_086 | 28 | expert | easy | 126 | 54 | hidden_single, naked_pair, naked_single | `000740080010050004042010305060009000000580400083400000630001000095030210000000600` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 126, and the rater has no Extreme output band. |
| extreme_133 | 27 | expert | easy | 126 | 55 | hidden_single, naked_pair, naked_single | `000400000908007010003008052796032001000006000000180000000000900080709040000040168` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 126, and the rater has no Extreme output band. |
| extreme_150 | 27 | expert | easy | 126 | 55 | hidden_single, naked_pair, naked_single | `890000630000900004005000008002509300908040726004000000500000060301807090000000200` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 126, and the rater has no Extreme output band. |
| extreme_165 | 27 | expert | easy | 126 | 55 | hidden_single, naked_pair, naked_single | `060804000030060800000700050009003000513000200000270000000900005350041000900307014` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 126, and the rater has no Extreme output band. |
| extreme_224 | 26 | expert | easy | 126 | 56 | hidden_single, naked_pair, naked_single | `000204000000007905008300020060143700000000006800900410000700008002008040000039001` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 126, and the rater has no Extreme output band. |
| extreme_239 | 26 | expert | easy | 126 | 56 | hidden_single, naked_pair, naked_single | `007004000020010005310000408000008362000170809000200000000009000080400150430600000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 126, and the rater has no Extreme output band. |
| extreme_051 | 28 | expert | easy | 125 | 54 | hidden_pair, hidden_single, naked_single | `000002705065980200010007000570000020400000006030090570000409000000021600002800043` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as easy with score 125, and the rater has no Extreme output band. |
| extreme_055 | 28 | expert | easy | 125 | 54 | hidden_single, naked_pair, naked_single | `600508010070000000004006508040000001790850040000340600080200000900005000567000230` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 125, and the rater has no Extreme output band. |
| extreme_071 | 28 | expert | easy | 125 | 54 | hidden_single, naked_pair, naked_single | `082060000000800007000903010001090200020001300906285000004009100250100030000034000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 125, and the rater has no Extreme output band. |
| extreme_091 | 28 | expert | easy | 125 | 54 | hidden_single, naked_pair, naked_single | `002100006000000803000004052080070005305806000240000000708200030009680000504000708` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 125, and the rater has no Extreme output band. |
| extreme_106 | 27 | expert | easy | 125 | 55 | hidden_single, naked_pair, naked_single | `067005000500100090010000052000000710835000009000290000008007006000000408050083071` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 125, and the rater has no Extreme output band. |
| extreme_118 | 27 | expert | easy | 125 | 56 | hidden_single, naked_pair, naked_single | `000100900080060000070400085000006001700000009201095760000000002597604000040300007` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 125, and the rater has no Extreme output band. |
| extreme_149 | 27 | expert | easy | 125 | 56 | hidden_single, naked_pair, naked_single | `709000635080006470305000000600070000000000100892601000530000000900062000000503008` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 125, and the rater has no Extreme output band. |
| extreme_181 | 27 | expert | easy | 125 | 55 | hidden_single, naked_pair, naked_single | `021604000900200008000000000200000700003040689609500000502001000106970002090000040` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 125, and the rater has no Extreme output band. |
| extreme_221 | 26 | expert | easy | 125 | 56 | hidden_single, naked_pair, naked_single | `000357910000019000200000000000500000008006000530180670040000100806000500902060007` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 125, and the rater has no Extreme output band. |
| extreme_014 | 29 | expert | easy | 124 | 53 | hidden_pair, hidden_single, naked_single | `408001602007000080260003000000008056005039800000500920823104000900080400001000000` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as easy with score 124, and the rater has no Extreme output band. |
| extreme_060 | 28 | expert | easy | 124 | 54 | hidden_single, naked_pair, naked_single | `070040900930000508504920060000050004800000700760090010400070085210000430000000000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 124, and the rater has no Extreme output band. |
| extreme_107 | 27 | expert | easy | 124 | 56 | hidden_single, naked_pair, naked_single | `004750000630014000008360000000600000000009270060143800900205000000800702000030010` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 124, and the rater has no Extreme output band. |
| extreme_011 | 30 | expert | easy | 123 | 53 | hidden_single, naked_pair, naked_single | `070000005648000000500719006064008700802003060000040050000067080005000607016800002` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 123, and the rater has no Extreme output band. |
| extreme_044 | 28 | expert | easy | 123 | 54 | hidden_single, naked_pair, naked_single | `319075000570006900602000070003500000780000000000600024050400000230700008804000050` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 123, and the rater has no Extreme output band. |
| extreme_049 | 28 | expert | easy | 123 | 54 | hidden_single, naked_single, pointing_pair | `500400000800053000000007309000034610002800005000006978403168000000095003050000000` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as easy with score 123, and the rater has no Extreme output band. |
| extreme_056 | 28 | expert | easy | 123 | 54 | hidden_single, naked_pair, naked_single | `700528000002690004000007000007300610600000500038200000010000060005060940280000057` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 123, and the rater has no Extreme output band. |
| extreme_065 | 28 | expert | easy | 123 | 54 | hidden_single, naked_pair, naked_single | `000030020000900001090507080000000002230009150015000007070040030900700014081003700` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 123, and the rater has no Extreme output band. |
| extreme_093 | 28 | expert | easy | 123 | 54 | hidden_single, naked_pair, naked_single | `900040005304000806050000430000030007040000950000805064000068200410057000030000009` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 123, and the rater has no Extreme output band. |
| extreme_116 | 27 | expert | easy | 123 | 55 | hidden_single, naked_pair, naked_single | `010020090703090406000604000060579004000060005000001200937000000008000700000030051` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 123, and the rater has no Extreme output band. |
| extreme_222 | 26 | expert | easy | 123 | 56 | hidden_single, naked_pair, naked_single | `500790000090206000086003070070300000400000038000051700900000302000045007000130000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 123, and the rater has no Extreme output band. |
| extreme_016 | 29 | expert | easy | 122 | 53 | hidden_single, naked_pair, naked_single | `058020600000098200000167008000009540000736009089000300701080000020040000000900025` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 122, and the rater has no Extreme output band. |
| extreme_098 | 28 | expert | easy | 122 | 54 | hidden_single, naked_pair, naked_single | `340008000002043600000271000008000056003007000001360002004500090280700000007030008` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 122, and the rater has no Extreme output band. |
| extreme_177 | 27 | expert | easy | 122 | 55 | hidden_single, naked_pair, naked_single | `040000005000043009076501000300004750000000003050000496008009000010200004030000917` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 122, and the rater has no Extreme output band. |
| extreme_054 | 28 | expert | easy | 121 | 54 | hidden_single, naked_pair, naked_single | `050071900092006000100000504010082007285060000060003000900000401000107098000030000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 121, and the rater has no Extreme output band. |
| extreme_062 | 28 | expert | easy | 121 | 54 | hidden_single, naked_pair, naked_single | `900203570002000000050604082075420000183007000000000000000740209000032100009000040` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 121, and the rater has no Extreme output band. |
| extreme_134 | 27 | expert | easy | 121 | 55 | hidden_single, naked_pair, naked_single | `000500000000036000600100548700400005040650000300097000900020300000060010080345006` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 121, and the rater has no Extreme output band. |
| extreme_153 | 28 | expert | easy | 121 | 54 | hidden_single, naked_single, pointing_pair | `024080030300040068010970204000001090040869000000700005009004500000600002000000079` | Considered hard/expert because it requires pointing_pair; not true Extreme because current rater classifies the puzzle as easy with score 121, and the rater has no Extreme output band. |
| extreme_257 | 26 | expert | easy | 121 | 56 | hidden_single, naked_pair, naked_single | `003006000025340000007080004600027080009800306100000000000000900502000400040200013` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 121, and the rater has no Extreme output band. |
| extreme_010 | 30 | expert | easy | 120 | 52 | hidden_single, naked_pair, naked_single | `006000024507000001042630570600970000009003010230005000400000002170800400008300100` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 120, and the rater has no Extreme output band. |
| extreme_019 | 29 | expert | easy | 120 | 53 | hidden_single, naked_pair, naked_single | `930004000000630870070005609800050200090300000107000008200083000010500983300000500` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 120, and the rater has no Extreme output band. |
| extreme_020 | 29 | expert | easy | 120 | 53 | hidden_single, naked_pair, naked_single | `056000000210900005800000320000000206160300054040002890671000000480060000020005007` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 120, and the rater has no Extreme output band. |
| extreme_092 | 28 | expert | easy | 120 | 54 | hidden_single, naked_pair, naked_single | `000002790004009001090800004100060000002008430006000089000005907203000040017080200` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 120, and the rater has no Extreme output band. |
| extreme_108 | 27 | expert | easy | 120 | 55 | hidden_single, naked_pair, naked_single | `002800000740100050601090000080700002306000000410003500070400320100000007050008400` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 120, and the rater has no Extreme output band. |
| extreme_022 | 29 | expert | easy | 119 | 53 | hidden_pair, hidden_single, naked_single | `063018009071029630040000000000840000390070040200000001000000006009350180400290000` | Considered hard/expert because it requires hidden_pair; not true Extreme because current rater classifies the puzzle as easy with score 119, and the rater has no Extreme output band. |
| extreme_027 | 28 | expert | easy | 119 | 54 | hidden_single, naked_pair, naked_single | `278005001000030827000000000000840276000000003760300410300000060800000904057090000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 119, and the rater has no Extreme output band. |
| extreme_080 | 28 | expert | easy | 119 | 54 | hidden_single, naked_pair, naked_single | `010006002078400000000503060000008040007290000031000059100080604006001300000602005` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 119, and the rater has no Extreme output band. |
| extreme_002 | 33 | expert | easy | 118 | 50 | hidden_single, naked_pair, naked_single, pointing_pair | `008027500200500000006418020834100200605304070019060000000002003000000890400800752` | Considered hard/expert because it requires naked_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as easy with score 118, and the rater has no Extreme output band. |
| extreme_003 | 33 | expert | easy | 118 | 50 | hidden_pair, hidden_single, naked_single, pointing_pair | `053062019000500600006079350700000000395806000080017003009004000002790800438001000` | Considered hard/expert because it requires hidden_pair, pointing_pair; not true Extreme because current rater classifies the puzzle as easy with score 118, and the rater has no Extreme output band. |
| extreme_008 | 30 | expert | easy | 118 | 52 | hidden_single, naked_pair, naked_single | `005200060020673040300408020050002000008706000670030002500800000010305480900020000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 118, and the rater has no Extreme output band. |
| extreme_012 | 30 | expert | easy | 118 | 52 | hidden_single, naked_pair, naked_single | `008139040000028000130500020090076000206000090001400006000803010000914000910050003` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 118, and the rater has no Extreme output band. |
| extreme_024 | 29 | expert | easy | 118 | 53 | hidden_single, naked_pair, naked_single | `162450000040070000900001000794030080000000000000907302078003006029500004601080000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 118, and the rater has no Extreme output band. |
| extreme_042 | 28 | expert | easy | 118 | 54 | hidden_single, naked_pair, naked_single | `810604000900080000240507130062000007050870001000006090600700200000000000080030940` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 118, and the rater has no Extreme output band. |
| extreme_120 | 27 | expert | easy | 117 | 55 | hidden_single, naked_pair, naked_single | `800000700020400090073090061500000087000519000000003900902604000600008100005020000` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 117, and the rater has no Extreme output band. |
| extreme_015 | 29 | expert | easy | 116 | 53 | hidden_single, naked_pair, naked_single | `200100000400023008080000050020019080708000009090074060000907040070000300054030890` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 116, and the rater has no Extreme output band. |
| extreme_001 | 38 | expert | easy | 100 | 44 | hidden_single, naked_pair, naked_single | `000002057942703008050810240004000190090300080685001403400007800028009060500128004` | Considered hard/expert because it requires naked_pair; not true Extreme because current rater classifies the puzzle as easy with score 100, and the rater has no Extreme output band. |

## Classification Mismatches

- extreme_001: stored difficulty expert does not match re-rated easy
- extreme_001: stored score 220 does not match re-rated 100
- extreme_002: stored difficulty expert does not match re-rated easy
- extreme_002: stored score 220 does not match re-rated 118
- extreme_003: stored difficulty expert does not match re-rated easy
- extreme_003: stored score 220 does not match re-rated 118
- extreme_004: stored difficulty expert does not match re-rated easy
- extreme_004: stored score 220 does not match re-rated 128
- extreme_005: stored difficulty expert does not match re-rated medium
- extreme_005: stored score 220 does not match re-rated 139
- extreme_006: stored difficulty expert does not match re-rated medium
- extreme_006: stored score 220 does not match re-rated 159
- extreme_007: stored difficulty expert does not match re-rated easy
- extreme_007: stored score 220 does not match re-rated 127
- extreme_008: stored difficulty expert does not match re-rated easy
- extreme_008: stored score 220 does not match re-rated 118
- extreme_009: stored difficulty expert does not match re-rated easy
- extreme_009: stored score 220 does not match re-rated 127
- extreme_010: stored difficulty expert does not match re-rated easy
- extreme_010: stored score 220 does not match re-rated 120
- extreme_011: stored difficulty expert does not match re-rated easy
- extreme_011: stored score 220 does not match re-rated 123
- extreme_012: stored difficulty expert does not match re-rated easy
- extreme_012: stored score 220 does not match re-rated 118
- extreme_013: stored difficulty expert does not match re-rated medium
- extreme_013: stored score 220 does not match re-rated 136
- extreme_014: stored difficulty expert does not match re-rated easy
- extreme_014: stored score 220 does not match re-rated 124
- extreme_015: stored difficulty expert does not match re-rated easy
- extreme_015: stored score 220 does not match re-rated 116
- extreme_016: stored difficulty expert does not match re-rated easy
- extreme_016: stored score 220 does not match re-rated 122
- extreme_017: stored difficulty expert does not match re-rated medium
- extreme_017: stored score 220 does not match re-rated 151
- extreme_018: stored difficulty expert does not match re-rated easy
- extreme_018: stored score 220 does not match re-rated 129
- extreme_019: stored difficulty expert does not match re-rated easy
- extreme_019: stored score 220 does not match re-rated 120
- extreme_020: stored difficulty expert does not match re-rated easy
- extreme_020: stored score 220 does not match re-rated 120
- extreme_021: stored difficulty expert does not match re-rated medium
- extreme_021: stored score 220 does not match re-rated 139
- extreme_022: stored difficulty expert does not match re-rated easy
- extreme_022: stored score 220 does not match re-rated 119
- extreme_023: stored difficulty expert does not match re-rated medium
- extreme_023: stored score 220 does not match re-rated 146
- extreme_024: stored difficulty expert does not match re-rated easy
- extreme_024: stored score 220 does not match re-rated 118
- extreme_025: stored difficulty expert does not match re-rated easy
- extreme_025: stored score 220 does not match re-rated 129
- extreme_026: stored difficulty expert does not match re-rated medium
- extreme_026: stored score 220 does not match re-rated 132
- extreme_027: stored difficulty expert does not match re-rated easy
- extreme_027: stored score 220 does not match re-rated 119
- extreme_028: stored difficulty expert does not match re-rated easy
- extreme_028: stored score 220 does not match re-rated 127
- extreme_029: stored difficulty expert does not match re-rated medium
- extreme_029: stored score 220 does not match re-rated 141
- extreme_030: stored difficulty expert does not match re-rated medium
- extreme_030: stored score 220 does not match re-rated 149
- extreme_031: stored difficulty expert does not match re-rated easy
- extreme_031: stored score 220 does not match re-rated 128
- extreme_032: stored difficulty expert does not match re-rated easy
- extreme_032: stored score 220 does not match re-rated 129
- extreme_033: stored difficulty expert does not match re-rated medium
- extreme_033: stored score 220 does not match re-rated 133
- extreme_034: stored difficulty expert does not match re-rated medium
- extreme_034: stored score 220 does not match re-rated 154
- extreme_035: stored difficulty expert does not match re-rated medium
- extreme_035: stored score 220 does not match re-rated 137
- extreme_036: stored difficulty expert does not match re-rated easy
- extreme_036: stored score 220 does not match re-rated 126
- extreme_037: stored difficulty expert does not match re-rated easy
- extreme_037: stored score 220 does not match re-rated 128
- extreme_038: stored difficulty expert does not match re-rated medium
- extreme_038: stored score 220 does not match re-rated 150
- extreme_039: stored difficulty expert does not match re-rated easy
- extreme_039: stored score 220 does not match re-rated 129
- extreme_040: stored difficulty expert does not match re-rated medium
- extreme_040: stored score 220 does not match re-rated 163
- extreme_041: stored difficulty expert does not match re-rated easy
- extreme_041: stored score 220 does not match re-rated 126
- extreme_042: stored difficulty expert does not match re-rated easy
- extreme_042: stored score 220 does not match re-rated 118
- extreme_043: stored difficulty expert does not match re-rated medium
- extreme_043: stored score 220 does not match re-rated 134
- extreme_044: stored difficulty expert does not match re-rated easy
- extreme_044: stored score 220 does not match re-rated 123
- extreme_045: stored difficulty expert does not match re-rated medium
- extreme_045: stored score 220 does not match re-rated 163
- extreme_046: stored difficulty expert does not match re-rated medium
- extreme_046: stored score 220 does not match re-rated 132
- extreme_047: stored difficulty expert does not match re-rated medium
- extreme_047: stored score 220 does not match re-rated 144
- extreme_048: stored difficulty expert does not match re-rated medium
- extreme_048: stored score 220 does not match re-rated 135
- extreme_049: stored difficulty expert does not match re-rated easy
- extreme_049: stored score 220 does not match re-rated 123
- extreme_050: stored difficulty expert does not match re-rated medium
- extreme_050: stored score 220 does not match re-rated 143
- extreme_051: stored difficulty expert does not match re-rated easy
- extreme_051: stored score 220 does not match re-rated 125
- extreme_052: stored difficulty expert does not match re-rated medium
- extreme_052: stored score 220 does not match re-rated 136
- extreme_053: stored difficulty expert does not match re-rated medium
- extreme_053: stored score 220 does not match re-rated 136
- extreme_054: stored difficulty expert does not match re-rated easy
- extreme_054: stored score 220 does not match re-rated 121
- extreme_055: stored difficulty expert does not match re-rated easy
- extreme_055: stored score 220 does not match re-rated 125
- extreme_056: stored difficulty expert does not match re-rated easy
- extreme_056: stored score 220 does not match re-rated 123
- extreme_057: stored difficulty expert does not match re-rated medium
- extreme_057: stored score 220 does not match re-rated 143
- extreme_058: stored difficulty expert does not match re-rated medium
- extreme_058: stored score 220 does not match re-rated 149
- extreme_059: stored difficulty expert does not match re-rated medium
- extreme_059: stored score 220 does not match re-rated 137
- extreme_060: stored difficulty expert does not match re-rated easy
- extreme_060: stored score 220 does not match re-rated 124
- extreme_061: stored difficulty expert does not match re-rated easy
- extreme_061: stored score 220 does not match re-rated 127
- extreme_062: stored difficulty expert does not match re-rated easy
- extreme_062: stored score 220 does not match re-rated 121
- extreme_063: stored difficulty expert does not match re-rated medium
- extreme_063: stored score 220 does not match re-rated 131
- extreme_064: stored difficulty expert does not match re-rated medium
- extreme_064: stored score 220 does not match re-rated 166
- extreme_065: stored difficulty expert does not match re-rated easy
- extreme_065: stored score 220 does not match re-rated 123
- extreme_066: stored difficulty expert does not match re-rated medium
- extreme_066: stored score 220 does not match re-rated 134
- extreme_067: stored difficulty expert does not match re-rated medium
- extreme_067: stored score 220 does not match re-rated 132
- extreme_068: stored difficulty expert does not match re-rated medium
- extreme_068: stored score 220 does not match re-rated 133
- extreme_069: stored difficulty expert does not match re-rated medium
- extreme_069: stored score 220 does not match re-rated 143
- extreme_070: stored difficulty expert does not match re-rated medium
- extreme_070: stored score 220 does not match re-rated 132
- extreme_071: stored difficulty expert does not match re-rated easy
- extreme_071: stored score 220 does not match re-rated 125
- extreme_072: stored difficulty expert does not match re-rated medium
- extreme_072: stored score 220 does not match re-rated 135
- extreme_073: stored difficulty expert does not match re-rated medium
- extreme_073: stored score 220 does not match re-rated 155
- extreme_074: stored difficulty expert does not match re-rated medium
- extreme_074: stored score 220 does not match re-rated 153
- extreme_075: stored difficulty expert does not match re-rated medium
- extreme_075: stored score 220 does not match re-rated 140
- extreme_076: stored difficulty expert does not match re-rated medium
- extreme_076: stored score 220 does not match re-rated 139
- extreme_077: stored difficulty expert does not match re-rated easy
- extreme_077: stored score 220 does not match re-rated 130
- extreme_078: stored difficulty expert does not match re-rated medium
- extreme_078: stored score 220 does not match re-rated 146
- extreme_079: stored difficulty expert does not match re-rated easy
- extreme_079: stored score 220 does not match re-rated 128
- extreme_080: stored difficulty expert does not match re-rated easy
- extreme_080: stored score 220 does not match re-rated 119
- extreme_081: stored difficulty expert does not match re-rated medium
- extreme_081: stored score 220 does not match re-rated 160
- extreme_082: stored difficulty expert does not match re-rated easy
- extreme_082: stored score 220 does not match re-rated 130
- extreme_083: stored difficulty expert does not match re-rated medium
- extreme_083: stored score 220 does not match re-rated 142
- extreme_084: stored difficulty expert does not match re-rated medium
- extreme_084: stored score 220 does not match re-rated 132
- extreme_085: stored difficulty expert does not match re-rated medium
- extreme_085: stored score 220 does not match re-rated 137
- extreme_086: stored difficulty expert does not match re-rated easy
- extreme_086: stored score 220 does not match re-rated 126
- extreme_087: stored difficulty expert does not match re-rated medium
- extreme_087: stored score 220 does not match re-rated 149
- extreme_088: stored difficulty expert does not match re-rated medium
- extreme_088: stored score 220 does not match re-rated 138
- extreme_089: stored difficulty expert does not match re-rated medium
- extreme_089: stored score 220 does not match re-rated 148
- extreme_090: stored difficulty expert does not match re-rated easy
- extreme_090: stored score 220 does not match re-rated 130
- extreme_091: stored difficulty expert does not match re-rated easy
- extreme_091: stored score 220 does not match re-rated 125
- extreme_092: stored difficulty expert does not match re-rated easy
- extreme_092: stored score 220 does not match re-rated 120
- extreme_093: stored difficulty expert does not match re-rated easy
- extreme_093: stored score 220 does not match re-rated 123
- extreme_094: stored difficulty expert does not match re-rated medium
- extreme_094: stored score 220 does not match re-rated 140
- extreme_095: stored difficulty expert does not match re-rated medium
- extreme_095: stored score 220 does not match re-rated 155
- extreme_096: stored difficulty expert does not match re-rated medium
- extreme_096: stored score 220 does not match re-rated 133
- extreme_097: stored difficulty expert does not match re-rated medium
- extreme_097: stored score 220 does not match re-rated 144
- extreme_098: stored difficulty expert does not match re-rated easy
- extreme_098: stored score 220 does not match re-rated 122
- extreme_099: stored difficulty expert does not match re-rated medium
- extreme_099: stored score 220 does not match re-rated 144
- extreme_100: stored difficulty expert does not match re-rated medium
- extreme_100: stored score 220 does not match re-rated 139
- extreme_101: stored difficulty expert does not match re-rated medium
- extreme_101: stored score 220 does not match re-rated 132
- extreme_102: stored difficulty expert does not match re-rated easy
- extreme_102: stored score 220 does not match re-rated 127
- extreme_103: stored difficulty expert does not match re-rated hard
- extreme_103: stored score 220 does not match re-rated 187
- extreme_104: stored difficulty expert does not match re-rated medium
- extreme_104: stored score 220 does not match re-rated 139
- extreme_105: stored difficulty expert does not match re-rated easy
- extreme_105: stored score 220 does not match re-rated 129
- extreme_106: stored difficulty expert does not match re-rated easy
- extreme_106: stored score 220 does not match re-rated 125
- extreme_107: stored difficulty expert does not match re-rated easy
- extreme_107: stored score 220 does not match re-rated 124
- extreme_108: stored difficulty expert does not match re-rated easy
- extreme_108: stored score 220 does not match re-rated 120
- extreme_109: stored difficulty expert does not match re-rated medium
- extreme_109: stored score 220 does not match re-rated 143
- extreme_110: stored difficulty expert does not match re-rated easy
- extreme_110: stored score 220 does not match re-rated 129
- extreme_111: stored difficulty expert does not match re-rated medium
- extreme_111: stored score 220 does not match re-rated 143
- extreme_112: stored difficulty expert does not match re-rated medium
- extreme_112: stored score 220 does not match re-rated 131
- extreme_113: stored difficulty expert does not match re-rated easy
- extreme_113: stored score 220 does not match re-rated 129
- extreme_114: stored difficulty expert does not match re-rated medium
- extreme_114: stored score 220 does not match re-rated 133
- extreme_115: stored difficulty expert does not match re-rated easy
- extreme_115: stored score 220 does not match re-rated 128
- extreme_116: stored difficulty expert does not match re-rated easy
- extreme_116: stored score 220 does not match re-rated 123
- extreme_117: stored difficulty expert does not match re-rated easy
- extreme_117: stored score 220 does not match re-rated 128
- extreme_118: stored difficulty expert does not match re-rated easy
- extreme_118: stored score 220 does not match re-rated 125
- extreme_119: stored difficulty expert does not match re-rated medium
- extreme_119: stored score 220 does not match re-rated 133
- extreme_120: stored difficulty expert does not match re-rated easy
- extreme_120: stored score 220 does not match re-rated 117
- extreme_121: stored difficulty expert does not match re-rated easy
- extreme_121: stored score 220 does not match re-rated 128
- extreme_122: stored difficulty expert does not match re-rated easy
- extreme_122: stored score 220 does not match re-rated 130
- extreme_123: stored difficulty expert does not match re-rated medium
- extreme_123: stored score 220 does not match re-rated 167
- extreme_124: stored difficulty expert does not match re-rated easy
- extreme_124: stored score 220 does not match re-rated 127
- extreme_125: stored difficulty expert does not match re-rated easy
- extreme_125: stored score 220 does not match re-rated 129
- extreme_126: stored difficulty expert does not match re-rated medium
- extreme_126: stored score 220 does not match re-rated 132
- extreme_127: stored difficulty expert does not match re-rated medium
- extreme_127: stored score 220 does not match re-rated 140
- extreme_128: stored difficulty expert does not match re-rated easy
- extreme_128: stored score 220 does not match re-rated 128
- extreme_129: stored difficulty expert does not match re-rated medium
- extreme_129: stored score 220 does not match re-rated 154
- extreme_130: stored difficulty expert does not match re-rated medium
- extreme_130: stored score 220 does not match re-rated 139
- extreme_131: stored difficulty expert does not match re-rated medium
- extreme_131: stored score 220 does not match re-rated 134
- extreme_132: stored difficulty expert does not match re-rated medium
- extreme_132: stored score 220 does not match re-rated 131
- extreme_133: stored difficulty expert does not match re-rated easy
- extreme_133: stored score 220 does not match re-rated 126
- extreme_134: stored difficulty expert does not match re-rated easy
- extreme_134: stored score 220 does not match re-rated 121
- extreme_135: stored difficulty expert does not match re-rated medium
- extreme_135: stored score 220 does not match re-rated 170
- extreme_136: stored difficulty expert does not match re-rated hard
- extreme_136: stored score 220 does not match re-rated 181
- extreme_137: stored difficulty expert does not match re-rated medium
- extreme_137: stored score 220 does not match re-rated 146
- extreme_138: stored difficulty expert does not match re-rated medium
- extreme_138: stored score 220 does not match re-rated 170
- extreme_139: stored difficulty expert does not match re-rated easy
- extreme_139: stored score 220 does not match re-rated 129
- extreme_140: stored difficulty expert does not match re-rated easy
- extreme_140: stored score 220 does not match re-rated 127
- extreme_141: stored difficulty expert does not match re-rated easy
- extreme_141: stored score 220 does not match re-rated 129
- extreme_142: stored difficulty expert does not match re-rated medium
- extreme_142: stored score 220 does not match re-rated 140
- extreme_143: stored difficulty expert does not match re-rated medium
- extreme_143: stored score 220 does not match re-rated 144
- extreme_144: stored difficulty expert does not match re-rated easy
- extreme_144: stored score 220 does not match re-rated 129
- extreme_145: stored difficulty expert does not match re-rated medium
- extreme_145: stored score 220 does not match re-rated 171
- extreme_146: stored difficulty expert does not match re-rated medium
- extreme_146: stored score 220 does not match re-rated 141
- extreme_147: stored difficulty expert does not match re-rated medium
- extreme_147: stored score 220 does not match re-rated 132
- extreme_148: stored difficulty expert does not match re-rated medium
- extreme_148: stored score 220 does not match re-rated 171
- extreme_149: stored difficulty expert does not match re-rated easy
- extreme_149: stored score 220 does not match re-rated 125
- extreme_150: stored difficulty expert does not match re-rated easy
- extreme_150: stored score 220 does not match re-rated 126
- extreme_151: stored difficulty expert does not match re-rated medium
- extreme_151: stored score 220 does not match re-rated 168
- extreme_152: stored difficulty expert does not match re-rated medium
- extreme_152: stored score 220 does not match re-rated 144
- extreme_153: stored difficulty expert does not match re-rated easy
- extreme_153: stored score 220 does not match re-rated 121
- extreme_154: stored difficulty expert does not match re-rated medium
- extreme_154: stored score 220 does not match re-rated 141
- extreme_155: stored difficulty expert does not match re-rated medium
- extreme_155: stored score 220 does not match re-rated 135
- extreme_156: stored difficulty expert does not match re-rated hard
- extreme_156: stored score 220 does not match re-rated 195
- extreme_157: stored difficulty expert does not match re-rated easy
- extreme_157: stored score 220 does not match re-rated 130
- extreme_158: stored difficulty expert does not match re-rated medium
- extreme_158: stored score 220 does not match re-rated 159
- extreme_159: stored difficulty expert does not match re-rated medium
- extreme_159: stored score 220 does not match re-rated 134
- extreme_160: stored difficulty expert does not match re-rated medium
- extreme_160: stored score 220 does not match re-rated 131
- extreme_161: stored difficulty expert does not match re-rated medium
- extreme_161: stored score 220 does not match re-rated 148
- extreme_162: stored difficulty expert does not match re-rated medium
- extreme_162: stored score 220 does not match re-rated 132
- extreme_163: stored difficulty expert does not match re-rated medium
- extreme_163: stored score 220 does not match re-rated 142
- extreme_164: stored difficulty expert does not match re-rated easy
- extreme_164: stored score 220 does not match re-rated 128
- extreme_165: stored difficulty expert does not match re-rated easy
- extreme_165: stored score 220 does not match re-rated 126
- extreme_166: stored difficulty expert does not match re-rated medium
- extreme_166: stored score 220 does not match re-rated 138
- extreme_167: stored difficulty expert does not match re-rated medium
- extreme_167: stored score 220 does not match re-rated 132
- extreme_168: stored difficulty expert does not match re-rated medium
- extreme_168: stored score 220 does not match re-rated 134
- extreme_169: stored difficulty expert does not match re-rated medium
- extreme_169: stored score 220 does not match re-rated 131
- extreme_170: stored difficulty expert does not match re-rated medium
- extreme_170: stored score 220 does not match re-rated 139
- extreme_171: stored difficulty expert does not match re-rated medium
- extreme_171: stored score 220 does not match re-rated 131
- extreme_172: stored difficulty expert does not match re-rated medium
- extreme_172: stored score 220 does not match re-rated 153
- extreme_173: stored difficulty expert does not match re-rated medium
- extreme_173: stored score 220 does not match re-rated 148
- extreme_174: stored difficulty expert does not match re-rated medium
- extreme_174: stored score 220 does not match re-rated 138
- extreme_175: stored difficulty expert does not match re-rated hard
- extreme_175: stored score 220 does not match re-rated 190
- extreme_176: stored difficulty expert does not match re-rated easy
- extreme_176: stored score 220 does not match re-rated 128
- extreme_177: stored difficulty expert does not match re-rated easy
- extreme_177: stored score 220 does not match re-rated 122
- extreme_178: stored difficulty expert does not match re-rated medium
- extreme_178: stored score 220 does not match re-rated 163
- extreme_179: stored difficulty expert does not match re-rated easy
- extreme_179: stored score 220 does not match re-rated 128
- extreme_180: stored difficulty expert does not match re-rated medium
- extreme_180: stored score 220 does not match re-rated 153
- extreme_181: stored difficulty expert does not match re-rated easy
- extreme_181: stored score 220 does not match re-rated 125
- extreme_182: stored difficulty expert does not match re-rated medium
- extreme_182: stored score 220 does not match re-rated 143
- extreme_183: stored difficulty expert does not match re-rated medium
- extreme_183: stored score 220 does not match re-rated 132
- extreme_184: stored difficulty expert does not match re-rated medium
- extreme_184: stored score 220 does not match re-rated 136
- extreme_185: stored difficulty expert does not match re-rated easy
- extreme_185: stored score 220 does not match re-rated 128
- extreme_186: stored difficulty expert does not match re-rated medium
- extreme_186: stored score 220 does not match re-rated 146
- extreme_187: stored difficulty expert does not match re-rated medium
- extreme_187: stored score 220 does not match re-rated 153
- extreme_188: stored difficulty expert does not match re-rated medium
- extreme_188: stored score 220 does not match re-rated 132
- extreme_189: stored difficulty expert does not match re-rated medium
- extreme_189: stored score 220 does not match re-rated 138
- extreme_190: stored difficulty expert does not match re-rated medium
- extreme_190: stored score 220 does not match re-rated 146
- extreme_191: stored difficulty expert does not match re-rated medium
- extreme_191: stored score 220 does not match re-rated 152
- extreme_192: stored difficulty expert does not match re-rated medium
- extreme_192: stored score 220 does not match re-rated 152
- extreme_193: stored difficulty expert does not match re-rated medium
- extreme_193: stored score 220 does not match re-rated 134
- extreme_194: stored difficulty expert does not match re-rated easy
- extreme_194: stored score 220 does not match re-rated 130
- extreme_195: stored difficulty expert does not match re-rated medium
- extreme_195: stored score 220 does not match re-rated 180
- extreme_196: stored difficulty expert does not match re-rated medium
- extreme_196: stored score 220 does not match re-rated 135
- extreme_197: stored difficulty expert does not match re-rated medium
- extreme_197: stored score 220 does not match re-rated 145
- extreme_198: stored difficulty expert does not match re-rated medium
- extreme_198: stored score 220 does not match re-rated 135
- extreme_199: stored difficulty expert does not match re-rated medium
- extreme_199: stored score 220 does not match re-rated 132
- extreme_200: stored difficulty expert does not match re-rated easy
- extreme_200: stored score 220 does not match re-rated 127
- extreme_201: stored difficulty expert does not match re-rated medium
- extreme_201: stored score 220 does not match re-rated 174
- extreme_202: stored difficulty expert does not match re-rated medium
- extreme_202: stored score 220 does not match re-rated 141
- extreme_203: stored difficulty expert does not match re-rated medium
- extreme_203: stored score 220 does not match re-rated 135
- extreme_204: stored difficulty expert does not match re-rated medium
- extreme_204: stored score 220 does not match re-rated 136
- extreme_205: stored difficulty expert does not match re-rated medium
- extreme_205: stored score 220 does not match re-rated 142
- extreme_206: stored difficulty expert does not match re-rated medium
- extreme_206: stored score 220 does not match re-rated 134
- extreme_207: stored difficulty expert does not match re-rated medium
- extreme_207: stored score 220 does not match re-rated 132
- extreme_208: stored difficulty expert does not match re-rated medium
- extreme_208: stored score 220 does not match re-rated 165
- extreme_209: stored difficulty expert does not match re-rated medium
- extreme_209: stored score 220 does not match re-rated 152
- extreme_210: stored difficulty expert does not match re-rated medium
- extreme_210: stored score 220 does not match re-rated 150
- extreme_211: stored difficulty expert does not match re-rated medium
- extreme_211: stored score 220 does not match re-rated 138
- extreme_212: stored difficulty expert does not match re-rated medium
- extreme_212: stored score 220 does not match re-rated 180
- extreme_213: stored difficulty expert does not match re-rated medium
- extreme_213: stored score 220 does not match re-rated 163
- extreme_214: stored difficulty expert does not match re-rated medium
- extreme_214: stored score 220 does not match re-rated 137
- extreme_215: stored difficulty expert does not match re-rated medium
- extreme_215: stored score 220 does not match re-rated 136
- extreme_216: stored difficulty expert does not match re-rated medium
- extreme_216: stored score 220 does not match re-rated 166
- extreme_217: stored difficulty expert does not match re-rated medium
- extreme_217: stored score 220 does not match re-rated 174
- extreme_218: stored difficulty expert does not match re-rated easy
- extreme_218: stored score 220 does not match re-rated 127
- extreme_219: stored difficulty expert does not match re-rated medium
- extreme_219: stored score 220 does not match re-rated 150
- extreme_220: stored difficulty expert does not match re-rated medium
- extreme_220: stored score 220 does not match re-rated 149
- extreme_221: stored difficulty expert does not match re-rated easy
- extreme_221: stored score 220 does not match re-rated 125
- extreme_222: stored difficulty expert does not match re-rated easy
- extreme_222: stored score 220 does not match re-rated 123
- extreme_223: stored difficulty expert does not match re-rated medium
- extreme_223: stored score 220 does not match re-rated 145
- extreme_224: stored difficulty expert does not match re-rated easy
- extreme_224: stored score 220 does not match re-rated 126
- extreme_225: stored difficulty expert does not match re-rated medium
- extreme_225: stored score 220 does not match re-rated 131
- extreme_226: stored difficulty expert does not match re-rated medium
- extreme_226: stored score 220 does not match re-rated 134
- extreme_227: stored difficulty expert does not match re-rated medium
- extreme_227: stored score 220 does not match re-rated 154
- extreme_228: stored difficulty expert does not match re-rated easy
- extreme_228: stored score 220 does not match re-rated 127
- extreme_229: stored difficulty expert does not match re-rated medium
- extreme_229: stored score 220 does not match re-rated 148
- extreme_230: stored difficulty expert does not match re-rated medium
- extreme_230: stored score 220 does not match re-rated 136
- extreme_231: stored difficulty expert does not match re-rated medium
- extreme_231: stored score 220 does not match re-rated 147
- extreme_232: stored difficulty expert does not match re-rated easy
- extreme_232: stored score 220 does not match re-rated 127
- extreme_233: stored difficulty expert does not match re-rated medium
- extreme_233: stored score 220 does not match re-rated 134
- extreme_234: stored difficulty expert does not match re-rated medium
- extreme_234: stored score 220 does not match re-rated 151
- extreme_235: stored difficulty expert does not match re-rated medium
- extreme_235: stored score 220 does not match re-rated 159
- extreme_236: stored difficulty expert does not match re-rated medium
- extreme_236: stored score 220 does not match re-rated 132
- extreme_237: stored difficulty expert does not match re-rated medium
- extreme_237: stored score 220 does not match re-rated 152
- extreme_238: stored difficulty expert does not match re-rated medium
- extreme_238: stored score 220 does not match re-rated 148
- extreme_239: stored difficulty expert does not match re-rated easy
- extreme_239: stored score 220 does not match re-rated 126
- extreme_240: stored difficulty expert does not match re-rated hard
- extreme_240: stored score 220 does not match re-rated 184
- extreme_241: stored difficulty expert does not match re-rated medium
- extreme_241: stored score 220 does not match re-rated 134
- extreme_242: stored difficulty expert does not match re-rated easy
- extreme_242: stored score 220 does not match re-rated 130
- extreme_243: stored difficulty expert does not match re-rated easy
- extreme_243: stored score 220 does not match re-rated 130
- extreme_244: stored difficulty expert does not match re-rated medium
- extreme_244: stored score 220 does not match re-rated 139
- extreme_245: stored difficulty expert does not match re-rated medium
- extreme_245: stored score 220 does not match re-rated 132
- extreme_246: stored difficulty expert does not match re-rated easy
- extreme_246: stored score 220 does not match re-rated 130
- extreme_247: stored difficulty expert does not match re-rated easy
- extreme_247: stored score 220 does not match re-rated 130
- extreme_248: stored difficulty expert does not match re-rated medium
- extreme_248: stored score 220 does not match re-rated 131
- extreme_249: stored difficulty expert does not match re-rated medium
- extreme_249: stored score 220 does not match re-rated 141
- extreme_250: stored difficulty expert does not match re-rated medium
- extreme_250: stored score 220 does not match re-rated 153
- extreme_251: stored difficulty expert does not match re-rated medium
- extreme_251: stored score 220 does not match re-rated 166
- extreme_252: stored difficulty expert does not match re-rated medium
- extreme_252: stored score 220 does not match re-rated 140
- extreme_253: stored difficulty expert does not match re-rated medium
- extreme_253: stored score 220 does not match re-rated 138
- extreme_254: stored difficulty expert does not match re-rated medium
- extreme_254: stored score 220 does not match re-rated 137
- extreme_255: stored difficulty expert does not match re-rated medium
- extreme_255: stored score 220 does not match re-rated 155
- extreme_256: stored difficulty expert does not match re-rated medium
- extreme_256: stored score 220 does not match re-rated 162
- extreme_257: stored difficulty expert does not match re-rated easy
- extreme_257: stored score 220 does not match re-rated 121
- extreme_258: stored difficulty expert does not match re-rated medium
- extreme_258: stored score 220 does not match re-rated 131
- extreme_259: stored difficulty expert does not match re-rated medium
- extreme_259: stored score 220 does not match re-rated 135
- extreme_260: stored difficulty expert does not match re-rated medium
- extreme_260: stored score 220 does not match re-rated 149
- extreme_261: stored difficulty expert does not match re-rated medium
- extreme_261: stored score 220 does not match re-rated 134
- extreme_262: stored difficulty expert does not match re-rated medium
- extreme_262: stored score 220 does not match re-rated 142
- extreme_263: stored difficulty expert does not match re-rated medium
- extreme_263: stored score 220 does not match re-rated 131
- extreme_264: stored difficulty expert does not match re-rated medium
- extreme_264: stored score 220 does not match re-rated 135
- extreme_265: stored difficulty expert does not match re-rated medium
- extreme_265: stored score 220 does not match re-rated 134
- extreme_266: stored difficulty expert does not match re-rated medium
- extreme_266: stored score 220 does not match re-rated 144
- extreme_267: stored difficulty expert does not match re-rated medium
- extreme_267: stored score 220 does not match re-rated 132
- extreme_268: stored difficulty expert does not match re-rated medium
- extreme_268: stored score 220 does not match re-rated 136
- extreme_269: stored difficulty expert does not match re-rated medium
- extreme_269: stored score 220 does not match re-rated 164
- extreme_270: stored difficulty expert does not match re-rated medium
- extreme_270: stored score 220 does not match re-rated 141
