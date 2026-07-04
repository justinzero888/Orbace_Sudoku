# Mastery Puzzle Audit

Date: 2026-07-02

## Source

- Manifest pack id: `mastery`
- Manifest title: `Mastery`
- Manifest difficultyBand: `hard`
- Assets:
  - `assets/puzzles/mastery/mastery_01.json`
  - `assets/puzzles/mastery/mastery_02.json`
  - `assets/puzzles/mastery/mastery_03.json`
  - `assets/puzzles/mastery/mastery_04.json`
  - `assets/puzzles/mastery/mastery_05.json`

## Summary

- Re-rated difficulty counts: {hard: 1, medium: 123, easy: 146}; score range: 112-181; average score: 131.7; advanced-technique puzzles: 270/270.
- Integrity failures: 0
- Difficulty classification mismatches: 539
- Current app logic does not produce `SudokuDifficulty.extreme`; the difficulty rater only maps scores above 240 to `expert`.

## Puzzles

| ID | Clues | Stored | Re-rated | Score | Steps | Techniques | 81-cell givens | Audit reason |
| --- | ---: | --- | --- | ---: | ---: | --- | --- | --- |
| mastery_210 | 28 | hard | hard | 181 | 60 | hidden_pair, hidden_single, naked_single, pointing_pair | `100720035000400000305000700701204583020000071800000000030000900000386007200040000` | Requires hidden_pair, pointing_pair; current rater classifies the puzzle as hard with score 181. |
| mastery_154 | 29 | hard | medium | 179 | 60 | hidden_pair, hidden_single, naked_pair, naked_single | `000800605030010080004006000800030009960080203340005070750000006400003050003009010` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 179. |
| mastery_134 | 29 | hard | medium | 172 | 58 | hidden_single, naked_pair, naked_single, pointing_pair | `070490000080003007506000090060750009000040000020000340017004005050970084000205900` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 172. |
| mastery_257 | 28 | hard | medium | 168 | 58 | hidden_single, naked_pair, naked_single, pointing_pair | `185020670000500000020046000003054010406108037000000060700000080030000500504000006` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 168. |
| mastery_226 | 28 | hard | medium | 167 | 59 | hidden_pair, hidden_single, naked_single, pointing_pair | `069000002000103060200600078900000000000000740500801029094000200150302000000074800` | Requires hidden_pair, pointing_pair; current rater classifies the puzzle as medium with score 167. |
| mastery_192 | 28 | hard | medium | 165 | 58 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `058000070000040100163009400300000001000600700000501062000090503900103607000060040` | Requires hidden_pair, naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 165. |
| mastery_084 | 29 | hard | medium | 163 | 57 | hidden_single, naked_single, pointing_pair | `508000004090730025030000000004003000080409003005000010000050908000300257000068341` | Requires pointing_pair; current rater classifies the puzzle as medium with score 163. |
| mastery_209 | 28 | hard | medium | 163 | 57 | hidden_single, naked_single, pointing_pair | `002000000004020591090700030000000009000060183100005200027900000900054007005302010` | Requires pointing_pair; current rater classifies the puzzle as medium with score 163. |
| mastery_131 | 29 | hard | medium | 161 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `400100290020050801007000000702005100905000300000030059000090010001873940200000700` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 161. |
| mastery_258 | 28 | hard | medium | 161 | 58 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `100706000002901780000420000000608072069000003000140000001007004000010200706300010` | Requires hidden_pair, naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 161. |
| mastery_079 | 30 | hard | medium | 160 | 56 | hidden_single, naked_single, pointing_pair | `300650020270103000000000134040006070000000003603890400000005000800204301001000247` | Requires pointing_pair; current rater classifies the puzzle as medium with score 160. |
| mastery_164 | 28 | hard | medium | 160 | 59 | hidden_pair, hidden_single, naked_pair, naked_single | `308000000000900045600001090000812903001500400003700081700000060800090700000100032` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 160. |
| mastery_188 | 28 | hard | medium | 160 | 57 | hidden_pair, hidden_single, naked_single, pointing_pair | `007200003090050000080000902700000345020040000500090200006907030000031004003060720` | Requires hidden_pair, pointing_pair; current rater classifies the puzzle as medium with score 160. |
| mastery_204 | 28 | hard | medium | 157 | 59 | hidden_single, naked_pair, naked_single | `390000010000000379200007064700060048000014002000205600000002406970000080003000020` | Requires naked_pair; current rater classifies the puzzle as medium with score 157. |
| mastery_265 | 28 | hard | medium | 157 | 56 | hidden_single, naked_single, pointing_pair | `000900804800653000000000563000009080400002100302500009010000008000368005030000207` | Requires pointing_pair; current rater classifies the puzzle as medium with score 157. |
| mastery_152 | 29 | hard | medium | 156 | 57 | hidden_pair, hidden_single, naked_pair, naked_single | `080040005040100070030082060000801947700050000000407006010900600460003000070004020` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 156. |
| mastery_191 | 28 | hard | medium | 155 | 56 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `090060032003007806000100004070096000000300040000010069700000400500401097300009200` | Requires hidden_pair, naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 155. |
| mastery_132 | 29 | hard | medium | 154 | 56 | hidden_pair, hidden_single, naked_pair, naked_single | `000000000402905300900630080800590600070040005020100030008054100790080000040700003` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 154. |
| mastery_089 | 29 | hard | medium | 152 | 56 | hidden_pair, hidden_single, naked_single, pointing_pair | `000000300050000040309170020003801700090000000006023810238010056900000003060208000` | Requires hidden_pair, pointing_pair; current rater classifies the puzzle as medium with score 152. |
| mastery_146 | 29 | hard | medium | 152 | 56 | hidden_pair, hidden_single, naked_pair, naked_single | `500018070074000981000047060008070000000289100030400200040600813009000040000700000` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 152. |
| mastery_211 | 28 | hard | medium | 152 | 57 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `000000528000000000109200040710800005002100389903020000200904000008000000090580602` | Requires hidden_pair, naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 152. |
| mastery_054 | 30 | hard | medium | 151 | 55 | hidden_single, naked_single, pointing_pair | `068250791205090000009006004020000900900042517000000040000075000103000400007100008` | Requires pointing_pair; current rater classifies the puzzle as medium with score 151. |
| mastery_081 | 29 | hard | medium | 151 | 55 | hidden_single, naked_single, pointing_pair | `057000100000540009002000470746000300000006050005130060024008007900700000670004900` | Requires pointing_pair; current rater classifies the puzzle as medium with score 151. |
| mastery_174 | 28 | hard | medium | 150 | 57 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `000070200007000061800401070680000005030000047000395000253000000460710500900000004` | Requires hidden_pair, naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 150. |
| mastery_214 | 28 | hard | medium | 150 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `097600000000003000810200793041507000035080040600000030120000009003000000570000820` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 150. |
| mastery_092 | 29 | hard | medium | 149 | 56 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `008700103005009007070000080400510098000200705000090060804102009090000001200030040` | Requires hidden_pair, naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 149. |
| mastery_097 | 29 | hard | medium | 149 | 56 | hidden_single, naked_pair, naked_single, pointing_pair | `000904000403020700600000003006000370004009800005340200051070030007600500060512000` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 149. |
| mastery_150 | 29 | hard | medium | 149 | 56 | hidden_single, naked_pair, naked_single | `000028003000700960700690208009300700000800030012005609000007826080000400900006000` | Requires naked_pair; current rater classifies the puzzle as medium with score 149. |
| mastery_216 | 28 | hard | medium | 149 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `004800000610400030238060000900000040006010002007208050000000001570900060003007409` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 149. |
| mastery_221 | 28 | hard | medium | 149 | 57 | hidden_single, naked_pair, naked_single, pointing_pair | `640090007750204100001000200205400008070006001000307000089052004020040000000000700` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 149. |
| mastery_241 | 28 | hard | medium | 149 | 56 | hidden_pair, hidden_single, naked_pair, naked_single | `000470286007000000600900003070004000800030000426508300008390060000007002000002930` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 149. |
| mastery_121 | 29 | hard | medium | 148 | 56 | hidden_single, naked_pair, naked_single | `070400000086305001200080030000000004005007106702060050600000019400000072020100680` | Requires naked_pair; current rater classifies the puzzle as medium with score 148. |
| mastery_196 | 28 | hard | medium | 148 | 56 | hidden_single, naked_pair, naked_single, pointing_pair | `000310098002960000000007100004000000100020054009000713890000020200090401001030005` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 148. |
| mastery_038 | 30 | hard | medium | 146 | 55 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `000600900940003000000094273002030000860001300005986000003000640050400000604012080` | Requires hidden_pair, naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 146. |
| mastery_083 | 29 | hard | medium | 146 | 56 | hidden_pair, hidden_single, naked_pair, naked_single | `030005000002010000000827341100000000203590760070000009004150000900008105005009200` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 146. |
| mastery_102 | 29 | hard | medium | 146 | 55 | hidden_pair, hidden_single, naked_pair, naked_single | `040080007006901000285000000350700090000200704007008053603400000070000326500020000` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 146. |
| mastery_104 | 29 | hard | medium | 146 | 56 | hidden_single, naked_pair, naked_single, pointing_pair | `309000802020370060050000007000701000091000204508000009407905000900002473080000000` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 146. |
| mastery_160 | 28 | hard | medium | 146 | 58 | hidden_single, naked_pair, naked_single | `230948000750000000004710000000000000010300028040091003020000000190607034005430000` | Requires naked_pair; current rater classifies the puzzle as medium with score 146. |
| mastery_099 | 29 | hard | medium | 145 | 56 | hidden_single, naked_pair, naked_single, pointing_pair | `407300005090000700001002093000600000080950076004200510000000950700095040000160007` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 145. |
| mastery_114 | 29 | hard | medium | 145 | 55 | hidden_pair, hidden_single, naked_pair, naked_single | `000300706005014000000007019000100000600040025000503070570061002100090500829005000` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 145. |
| mastery_118 | 29 | hard | medium | 145 | 56 | hidden_pair, hidden_single, naked_pair, naked_single | `004000198000000004010027000087340010100000403043000020000298040000106002090070060` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 145. |
| mastery_207 | 28 | hard | medium | 145 | 56 | hidden_pair, hidden_single, naked_pair, naked_single | `180000060004000030000045701001700000070003040300016200000207609006100000723009000` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 145. |
| mastery_137 | 29 | hard | medium | 144 | 56 | hidden_single, naked_pair, naked_single | `000040560080170300004000009001800006000217804800050000000095421400080000750000080` | Requires naked_pair; current rater classifies the puzzle as medium with score 144. |
| mastery_249 | 28 | hard | medium | 144 | 56 | hidden_single, naked_single, pointing_pair | `000002098007006004000100207503029000000860500100030970400050000700200001000004035` | Requires pointing_pair; current rater classifies the puzzle as medium with score 144. |
| mastery_001 | 34 | hard | medium | 143 | 51 | hidden_pair, hidden_single, naked_single, pointing_pair | `179800200030200000400971800390080100080100009020000460200319680800000000910650700` | Requires hidden_pair, pointing_pair; current rater classifies the puzzle as medium with score 143. |
| mastery_020 | 31 | hard | medium | 143 | 54 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `000900600580406002060010000000064230000702080000000405003040720200090048458020090` | Requires hidden_pair, naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 143. |
| mastery_086 | 29 | hard | medium | 143 | 55 | hidden_pair, hidden_single, naked_single, pointing_pair | `710060002008030041000000089001000800830050096400003500100308070000700064007000900` | Requires hidden_pair, pointing_pair; current rater classifies the puzzle as medium with score 143. |
| mastery_048 | 30 | hard | medium | 142 | 55 | hidden_single, naked_pair, naked_single, pointing_pair | `407600010010000090600080704040030900029710000503802000000060001070040089906000050` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 142. |
| mastery_184 | 28 | hard | medium | 142 | 56 | hidden_pair, hidden_single, naked_pair, naked_single | `300509400000001802000083000010300740007120060600900000083000004060002000240000970` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 142. |
| mastery_013 | 32 | hard | medium | 141 | 53 | hidden_pair, hidden_single, naked_pair, naked_single | `000007120597000000060003509004350000059000048700084090000070000900628400008435007` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 141. |
| mastery_044 | 30 | hard | medium | 141 | 54 | hidden_pair, hidden_single, naked_single, pointing_pair | `000408007420000000000501080000004309090205708004090200163002900000103005850040000` | Requires hidden_pair, pointing_pair; current rater classifies the puzzle as medium with score 141. |
| mastery_110 | 29 | hard | medium | 141 | 55 | hidden_single, naked_pair, naked_single, pointing_pair | `408060000000201005007580600001000358080010007070005096009006004010000003705090000` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 141. |
| mastery_229 | 28 | hard | medium | 141 | 55 | hidden_pair, hidden_single, naked_pair, naked_single | `000000090607000015000351004502010800000070020070000430005000080030900150060125000` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 141. |
| mastery_039 | 30 | hard | medium | 140 | 54 | hidden_single, naked_pair, naked_single, pointing_pair | `107059020000100000000030600002413008400000092070000001009002000524060070310700204` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 140. |
| mastery_091 | 29 | hard | medium | 140 | 54 | hidden_single, naked_single, pointing_pair | `078460020003000040000201700000070400800010937090800061080000009502003000000708050` | Requires pointing_pair; current rater classifies the puzzle as medium with score 140. |
| mastery_145 | 29 | hard | medium | 140 | 55 | hidden_single, naked_pair, naked_single, pointing_pair | `000000002060000170508000306040001037006000000109060004900100403204800001017300090` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 140. |
| mastery_262 | 28 | hard | medium | 140 | 55 | hidden_single, naked_pair, naked_single | `001450080002000100030070040004010050500064070000009006605080000103000564290000000` | Requires naked_pair; current rater classifies the puzzle as medium with score 140. |
| mastery_006 | 32 | hard | medium | 139 | 53 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `600905010300000486701408000200007500007090100900103000500000728000002045072000301` | Requires hidden_pair, naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 139. |
| mastery_178 | 28 | hard | medium | 139 | 56 | hidden_single, naked_pair, naked_single, pointing_pair | `000241900010597000509003000105068043000300090000050600000970300820000000000030050` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 139. |
| mastery_202 | 28 | hard | medium | 139 | 55 | hidden_single, naked_single, pointing_pair | `900002804000400005600510000400300608008000050023000000000200006150003000376908500` | Requires pointing_pair; current rater classifies the puzzle as medium with score 139. |
| mastery_230 | 28 | hard | medium | 139 | 56 | hidden_single, naked_pair, naked_single, pointing_pair | `000001000000700096740809000002000000007400609038600070070300000900104360306025000` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 139. |
| mastery_240 | 28 | hard | medium | 139 | 56 | hidden_single, naked_pair, naked_single | `850000003070002050600845000000284000000000706000063040002001060907320000400076000` | Requires naked_pair; current rater classifies the puzzle as medium with score 139. |
| mastery_254 | 28 | hard | medium | 139 | 56 | hidden_single, naked_pair, naked_single | `000600080598000600000000024080000000720000450000085710010009040009054301000307800` | Requires naked_pair; current rater classifies the puzzle as medium with score 139. |
| mastery_263 | 28 | hard | medium | 139 | 56 | hidden_single, naked_pair, naked_single, pointing_pair | `001897002000300098800060100000100680080005930000000004000602000543018006000040000` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 139. |
| mastery_066 | 30 | hard | medium | 138 | 54 | hidden_single, naked_pair, naked_single, pointing_pair | `001300800370000016000601750060500004000027600000108390050700028810006430000000000` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 138. |
| mastery_116 | 29 | hard | medium | 138 | 55 | hidden_pair, hidden_single, naked_pair, naked_single | `000000168000005000002610040009001007000800051150340000000056020605000800020109076` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 138. |
| mastery_203 | 28 | hard | medium | 138 | 55 | hidden_pair, hidden_single, naked_single, pointing_pair | `030407001706008000800300076204000503000740060000500000408159000900000640007000000` | Requires hidden_pair, pointing_pair; current rater classifies the puzzle as medium with score 138. |
| mastery_007 | 29 | hard | medium | 137 | 55 | hidden_single, naked_pair, naked_single | `040800000600050000030060475482030000000507000075008003700300591063000007000000608` | Requires naked_pair; current rater classifies the puzzle as medium with score 137. |
| mastery_042 | 30 | hard | medium | 137 | 53 | hidden_single, naked_single, pointing_pair | `000000068060002709047060302070006030010905004030000200025493007000007500000020400` | Requires pointing_pair; current rater classifies the puzzle as medium with score 137. |
| mastery_117 | 29 | hard | medium | 137 | 55 | hidden_pair, hidden_single, naked_pair, naked_single | `000003102300005609020600400000060004068000570900010806000201000002000005639000018` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 137. |
| mastery_138 | 29 | hard | medium | 137 | 55 | hidden_single, naked_pair, naked_single | `130000002000000856500702000009403000453078009000200500027900605000000400000300087` | Requires naked_pair; current rater classifies the puzzle as medium with score 137. |
| mastery_149 | 29 | hard | medium | 137 | 54 | hidden_single, naked_pair, naked_single, pointing_pair | `200000095086050002000407860000030024060042710090700000010590080000003000000008106` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 137. |
| mastery_183 | 28 | hard | medium | 137 | 55 | hidden_single, naked_pair, naked_single, pointing_pair | `050620000200071500001048000000094300000000076002167009000400258109000700000000090` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 137. |
| mastery_250 | 29 | hard | medium | 137 | 55 | hidden_single, naked_pair, naked_single | `902006070000503000000000816800650009000309400090481000000030008000000700327908060` | Requires naked_pair; current rater classifies the puzzle as medium with score 137. |
| mastery_268 | 28 | hard | medium | 137 | 56 | hidden_single, naked_pair, naked_single | `961520080070000000000700910000000004510002008702800590000000100000905000807300409` | Requires naked_pair; current rater classifies the puzzle as medium with score 137. |
| mastery_087 | 29 | hard | medium | 136 | 54 | hidden_single, naked_pair, naked_single | `009800003000006000050034690000308000200569000800040056080601579007400000000005008` | Requires naked_pair; current rater classifies the puzzle as medium with score 136. |
| mastery_190 | 28 | hard | medium | 136 | 56 | hidden_single, naked_single, pointing_pair | `180005070200009008039000000300000700007090206800400109020503000000020000503910400` | Requires pointing_pair; current rater classifies the puzzle as medium with score 136. |
| mastery_004 | 33 | hard | medium | 135 | 52 | hidden_single, naked_pair, naked_single | `060107804400060007731050209200000690890302001140090300000706000000010000314080000` | Requires naked_pair; current rater classifies the puzzle as medium with score 135. |
| mastery_033 | 30 | hard | medium | 135 | 52 | hidden_single, naked_single, pointing_pair | `005100080003402006010807200032000000100308050000070830078200500000000300324005008` | Requires pointing_pair; current rater classifies the puzzle as medium with score 135. |
| mastery_156 | 29 | hard | medium | 135 | 54 | hidden_single, naked_pair, naked_single | `040005001001006050000217068300000504000000012060040039000860040030070800206050000` | Requires naked_pair; current rater classifies the puzzle as medium with score 135. |
| mastery_206 | 28 | hard | medium | 135 | 55 | hidden_single, naked_pair, naked_single | `030200001400051000009000004008000010090007245024003087945000002000782000080000000` | Requires naked_pair; current rater classifies the puzzle as medium with score 135. |
| mastery_021 | 31 | hard | medium | 134 | 53 | hidden_single, naked_single, pointing_pair | `849000007000000000070000520690050031000431009013089000900208070286005900100900000` | Requires pointing_pair; current rater classifies the puzzle as medium with score 134. |
| mastery_056 | 30 | hard | medium | 134 | 53 | hidden_pair, hidden_single, naked_single | `508001020000800091910423000000040000896002000000609100300000004000508907609010008` | Requires hidden_pair; current rater classifies the puzzle as medium with score 134. |
| mastery_076 | 30 | hard | medium | 134 | 54 | hidden_single, naked_pair, naked_single | `400006002090200043700045619000052060000160000013000004000500000207034000060891000` | Requires naked_pair; current rater classifies the puzzle as medium with score 134. |
| mastery_101 | 29 | hard | medium | 134 | 54 | hidden_single, naked_pair, naked_single, pointing_pair | `004001980000900070580406000320000047005620100801000000900000702050700009007310000` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 134. |
| mastery_139 | 29 | hard | medium | 134 | 54 | hidden_single, naked_pair, naked_single | `803000005060000000279600300050004000000037009027500401400005006000300597090108000` | Requires naked_pair; current rater classifies the puzzle as medium with score 134. |
| mastery_157 | 29 | hard | medium | 134 | 54 | hidden_pair, hidden_single, naked_single, pointing_pair | `000090016060074930089000000506107004700400000000005200090512000800006100051040000` | Requires hidden_pair, pointing_pair; current rater classifies the puzzle as medium with score 134. |
| mastery_168 | 28 | hard | medium | 134 | 55 | hidden_single, naked_pair, naked_single | `001508090060130000000006030002007659090240000078000000017000004800360021000000080` | Requires naked_pair; current rater classifies the puzzle as medium with score 134. |
| mastery_173 | 29 | hard | medium | 134 | 55 | hidden_single, naked_pair, naked_single | `005000000001260907632000408006970000010002300820600000000026039000000280000359000` | Requires naked_pair; current rater classifies the puzzle as medium with score 134. |
| mastery_181 | 28 | hard | medium | 134 | 54 | hidden_single, naked_pair, naked_single | `006000372703150840000200001284000500000000000000004013001580230000000000302700005` | Requires naked_pair; current rater classifies the puzzle as medium with score 134. |
| mastery_199 | 28 | hard | medium | 134 | 55 | hidden_single, naked_pair, naked_single | `000005078600740000008000630000879210000004700009106000547000000000003540100050090` | Requires naked_pair; current rater classifies the puzzle as medium with score 134. |
| mastery_224 | 28 | hard | medium | 134 | 55 | hidden_single, naked_pair, naked_single | `607500001000000000900001267038010000095308000100975000000720000003000000000450186` | Requires naked_pair; current rater classifies the puzzle as medium with score 134. |
| mastery_260 | 28 | hard | medium | 134 | 55 | hidden_pair, hidden_single, naked_pair, naked_single | `000040089000070430435010000007000800050020000000100297508290000670004000900007008` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 134. |
| mastery_266 | 28 | hard | medium | 134 | 55 | hidden_single, naked_pair, naked_single, pointing_pair | `000103089000090604800040100020000578104000000000020000002000800503800241068000050` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 134. |
| mastery_062 | 30 | hard | medium | 133 | 53 | hidden_single, naked_pair, naked_single, pointing_pair | `070005206030028004826000000102000903000200060080300502060040000045802000000960030` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 133. |
| mastery_070 | 30 | hard | medium | 133 | 54 | hidden_pair, hidden_single, naked_pair, naked_single | `037900000104007950090000006300000400046008519901000003502000890000000100009150004` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 133. |
| mastery_115 | 29 | hard | medium | 133 | 54 | hidden_single, naked_pair, naked_single | `210070946096002037300000000002001000060000003173008502700000301030400060009000000` | Requires naked_pair; current rater classifies the puzzle as medium with score 133. |
| mastery_124 | 29 | hard | medium | 133 | 53 | hidden_pair, hidden_single, naked_single | `030010405400200079007000000300000500570030010000400008000900701010384000069001034` | Requires hidden_pair; current rater classifies the puzzle as medium with score 133. |
| mastery_128 | 29 | hard | medium | 133 | 53 | hidden_single, naked_pair, naked_single | `068000520004000000500070003020510670005000300040002050400020800800009230050107400` | Requires naked_pair; current rater classifies the puzzle as medium with score 133. |
| mastery_155 | 29 | hard | medium | 133 | 55 | hidden_single, naked_pair, naked_single, pointing_pair | `000905001950070083060080000080500006079000400040600012705800300000709000800420000` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 133. |
| mastery_162 | 28 | hard | medium | 133 | 54 | hidden_single, naked_pair, naked_single | `000307509051000000300005082010400090060000000000090125100800900005042070007000041` | Requires naked_pair; current rater classifies the puzzle as medium with score 133. |
| mastery_197 | 28 | hard | medium | 133 | 55 | hidden_single, naked_single, pointing_pair | `000002070187500000690107004000906800000820057000070000260000390704059200000000000` | Requires pointing_pair; current rater classifies the puzzle as medium with score 133. |
| mastery_228 | 28 | hard | medium | 133 | 55 | hidden_single, naked_pair, naked_single | `592070000001009080000063500100920005009005030000010006300000400005708000910002070` | Requires naked_pair; current rater classifies the puzzle as medium with score 133. |
| mastery_251 | 28 | hard | medium | 133 | 55 | hidden_pair, hidden_single, naked_pair, naked_single | `000036007000800030000700518840002090000007004000050001307904100052000480090000006` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 133. |
| mastery_264 | 28 | hard | medium | 133 | 55 | hidden_single, naked_pair, naked_single | `006000090940000072703104080000000560005200407100009000060700900510026000407000000` | Requires naked_pair; current rater classifies the puzzle as medium with score 133. |
| mastery_109 | 28 | hard | medium | 132 | 55 | hidden_single, naked_pair, naked_single | `206000070700002531010800020800070006000530700900001080000205000000080960038000050` | Requires naked_pair; current rater classifies the puzzle as medium with score 132. |
| mastery_113 | 29 | hard | medium | 132 | 54 | hidden_single, naked_pair, naked_single | `210000894037000050409000300000001030023600009900200007000012500000500700000084021` | Requires naked_pair; current rater classifies the puzzle as medium with score 132. |
| mastery_233 | 28 | hard | medium | 132 | 55 | hidden_pair, hidden_single, naked_pair, naked_single | `900000020240006001007000003450000000300712040100540830700903000000000400600270009` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 132. |
| mastery_239 | 28 | hard | medium | 132 | 54 | hidden_single, naked_pair, naked_single | `050000901000008200700016080000601840200000000061000009810400090670005400040760000` | Requires naked_pair; current rater classifies the puzzle as medium with score 132. |
| mastery_245 | 28 | hard | medium | 132 | 55 | hidden_pair, hidden_single, naked_pair, naked_single | `806070150000020040073010006098200005000030010000008600051080000900607000000050092` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 132. |
| mastery_023 | 31 | hard | medium | 131 | 51 | hidden_single, naked_pair, naked_single | `003700900407009000000056000970160008020003009005000206249000507050020063306000090` | Requires naked_pair; current rater classifies the puzzle as medium with score 131. |
| mastery_052 | 30 | hard | medium | 131 | 54 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `800000500016005400053094070600000090070000034004000265000079002162500007000120000` | Requires hidden_pair, naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 131. |
| mastery_055 | 30 | hard | medium | 131 | 54 | hidden_single, naked_pair, naked_single | `000310000000900410400856009056020040904000027070100300000400000003005700009031502` | Requires naked_pair; current rater classifies the puzzle as medium with score 131. |
| mastery_135 | 29 | hard | medium | 131 | 54 | hidden_single, naked_pair, naked_single | `005003000310700600000580390030040706760800904001060080070002030006098100000000000` | Requires naked_pair; current rater classifies the puzzle as medium with score 131. |
| mastery_167 | 28 | hard | medium | 131 | 55 | hidden_single, naked_single, pointing_pair | `000400070000065900030780005000020000000851000500600097100000030093018450400000108` | Requires pointing_pair; current rater classifies the puzzle as medium with score 131. |
| mastery_169 | 28 | hard | medium | 131 | 55 | hidden_single, naked_single, pointing_pair | `608000200400603070000090008900050012100904680000000403010060807300000000087200000` | Requires pointing_pair; current rater classifies the puzzle as medium with score 131. |
| mastery_171 | 28 | hard | medium | 131 | 55 | hidden_pair, hidden_single, naked_pair, naked_single | `360004002904000080000008700083600000000052830050103006031000200000000005420000068` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as medium with score 131. |
| mastery_186 | 28 | hard | medium | 131 | 55 | hidden_single, naked_single, pointing_pair | `000800100010002509000000032000090700076103000090506010001280090004005300000001820` | Requires pointing_pair; current rater classifies the puzzle as medium with score 131. |
| mastery_198 | 28 | hard | medium | 131 | 54 | hidden_single, naked_pair, naked_single | `020078000000400000495600000000049000062500409140000300200700003050004070700050120` | Requires naked_pair; current rater classifies the puzzle as medium with score 131. |
| mastery_200 | 28 | hard | medium | 131 | 54 | hidden_single, naked_pair, naked_single | `010000700405000809003005106059200000000310008006089000090050600200001080000000913` | Requires naked_pair; current rater classifies the puzzle as medium with score 131. |
| mastery_208 | 28 | hard | medium | 131 | 54 | hidden_single, naked_pair, naked_single | `401000000956001000000900007009060070500012080012000000647000509108005060000040800` | Requires naked_pair; current rater classifies the puzzle as medium with score 131. |
| mastery_218 | 28 | hard | medium | 131 | 55 | hidden_single, naked_pair, naked_single, pointing_pair | `071003600604050030000460000009700103003000050400008200000000326000000000320504710` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as medium with score 131. |
| mastery_248 | 28 | hard | medium | 131 | 54 | hidden_single, naked_pair, naked_single | `002000018003002000000180047090836002300000400001000080000210054008500900000069001` | Requires naked_pair; current rater classifies the puzzle as medium with score 131. |
| mastery_256 | 28 | hard | medium | 131 | 55 | hidden_single, naked_pair, naked_single | `070040080000100007003002460000380015150060090908000070480000700000000000500890032` | Requires naked_pair; current rater classifies the puzzle as medium with score 131. |
| mastery_034 | 30 | hard | easy | 130 | 52 | hidden_single, naked_pair, naked_single | `720093600001200039389010000800900105010400000603000080030000098008001502000000300` | Requires naked_pair; current rater classifies the puzzle as easy with score 130. |
| mastery_082 | 29 | hard | easy | 130 | 54 | hidden_single, naked_pair, naked_single | `000407060900000000032000004000009007890046000400300080000008409140600835085000076` | Requires naked_pair; current rater classifies the puzzle as easy with score 130. |
| mastery_085 | 29 | hard | easy | 130 | 54 | hidden_single, naked_pair, naked_single | `001090008035201000070080000009500000750034000010000007002800030680050921000010806` | Requires naked_pair; current rater classifies the puzzle as easy with score 130. |
| mastery_107 | 29 | hard | easy | 130 | 54 | hidden_single, naked_pair, naked_single | `009408000607001045084000002100209000000500001000007928000842030003096000000000609` | Requires naked_pair; current rater classifies the puzzle as easy with score 130. |
| mastery_136 | 29 | hard | easy | 130 | 53 | hidden_pair, hidden_single, naked_single | `010060952050004006000000000097050381005800090000906005700000008000200530000681009` | Requires hidden_pair; current rater classifies the puzzle as easy with score 130. |
| mastery_166 | 28 | hard | easy | 130 | 54 | hidden_single, naked_pair, naked_single | `080500000006004950000306800000630709479002008000009000040000000203860000807900003` | Requires naked_pair; current rater classifies the puzzle as easy with score 130. |
| mastery_176 | 28 | hard | easy | 130 | 54 | hidden_single, naked_pair, naked_single | `109065420000090700006020003004009800000000010590800002208000051040000000605200900` | Requires naked_pair; current rater classifies the puzzle as easy with score 130. |
| mastery_029 | 30 | hard | easy | 129 | 52 | hidden_single, naked_pair, naked_single | `500306800610040007008005001001000700020050086864000030080500643000600070430000000` | Requires naked_pair; current rater classifies the puzzle as easy with score 129. |
| mastery_105 | 29 | hard | easy | 129 | 53 | hidden_single, naked_pair, naked_single | `400000100007000829200010046000008000074005080893400600005000090001040060020109005` | Requires naked_pair; current rater classifies the puzzle as easy with score 129. |
| mastery_123 | 29 | hard | easy | 129 | 53 | hidden_single, naked_pair, naked_single | `530400000001730800000109075000900100010000096649500008000600001093807000400000500` | Requires naked_pair; current rater classifies the puzzle as easy with score 129. |
| mastery_177 | 28 | hard | easy | 129 | 54 | hidden_single, naked_pair, naked_single | `508003020000000000193700005400907500900000030285000060050800900370002010800000200` | Requires naked_pair; current rater classifies the puzzle as easy with score 129. |
| mastery_179 | 28 | hard | easy | 129 | 54 | hidden_single, naked_pair, naked_single | `692403050000020080008007620080040000000900000300002960009530006200804030000200000` | Requires naked_pair; current rater classifies the puzzle as easy with score 129. |
| mastery_185 | 28 | hard | easy | 129 | 55 | hidden_single, naked_pair, naked_single | `006000000095000063218607000000200031080310507000005000020000406647050010001000000` | Requires naked_pair; current rater classifies the puzzle as easy with score 129. |
| mastery_201 | 28 | hard | easy | 129 | 54 | hidden_single, naked_pair, naked_single | `307010008480000050000000739900040000610038500800700000000300605009067004000080020` | Requires naked_pair; current rater classifies the puzzle as easy with score 129. |
| mastery_217 | 28 | hard | easy | 129 | 55 | hidden_single, naked_pair, naked_single | `000158900000203508000600020850020100092304000000800000007002041003400050010000300` | Requires naked_pair; current rater classifies the puzzle as easy with score 129. |
| mastery_219 | 28 | hard | easy | 129 | 55 | hidden_single, naked_pair, naked_single | `004000730000000418930000000003001004020090087001420000070000005102500803000300240` | Requires naked_pair; current rater classifies the puzzle as easy with score 129. |
| mastery_237 | 28 | hard | easy | 129 | 54 | hidden_single, naked_pair, naked_single | `900080006007000530000309000000900008509248360042000000400190007025800000000507000` | Requires naked_pair; current rater classifies the puzzle as easy with score 129. |
| mastery_244 | 28 | hard | easy | 129 | 54 | hidden_single, naked_pair, naked_single | `005400020140082009802000000900001000000300402400500060280057000000800076000009240` | Requires naked_pair; current rater classifies the puzzle as easy with score 129. |
| mastery_053 | 30 | hard | easy | 128 | 52 | hidden_single, naked_pair, naked_single | `000009010970000805400358002100090020309007000020080350000070200000400083200800507` | Requires naked_pair; current rater classifies the puzzle as easy with score 128. |
| mastery_069 | 30 | hard | easy | 128 | 53 | hidden_single, naked_pair, naked_single | `790100060030000000002000035607010400004006519015020006040000050000040602200900301` | Requires naked_pair; current rater classifies the puzzle as easy with score 128. |
| mastery_096 | 29 | hard | easy | 128 | 54 | hidden_single, naked_pair, naked_single | `003400020000600008650000017090048070067200304040000209000026003000030840500010000` | Requires naked_pair; current rater classifies the puzzle as easy with score 128. |
| mastery_133 | 29 | hard | easy | 128 | 53 | hidden_single, naked_pair, naked_single | `960080051000006080300700906600000000089005600100070008000069003806003007030210000` | Requires naked_pair; current rater classifies the puzzle as easy with score 128. |
| mastery_223 | 28 | hard | easy | 128 | 54 | hidden_single, naked_pair, naked_single | `009020004000804005000090301694000010870900000300010906008002000010000560200100009` | Requires naked_pair; current rater classifies the puzzle as easy with score 128. |
| mastery_227 | 28 | hard | easy | 128 | 54 | hidden_single, naked_pair, naked_single | `075029600000000000100050409008094200000300004000216080096100800000902170300000000` | Requires naked_pair; current rater classifies the puzzle as easy with score 128. |
| mastery_235 | 28 | hard | easy | 128 | 54 | hidden_single, naked_single, pointing_pair | `003000794090100005020000160050000031000080607000200050006500089502000300080000012` | Requires pointing_pair; current rater classifies the puzzle as easy with score 128. |
| mastery_246 | 28 | hard | easy | 128 | 54 | hidden_single, naked_pair, naked_single | `030000001900006083000800200090073500000200307670000000008049700009100830120000900` | Requires naked_pair; current rater classifies the puzzle as easy with score 128. |
| mastery_024 | 31 | hard | easy | 127 | 52 | hidden_pair, hidden_single, naked_pair, naked_single | `700005600098710030203609004009140006000350800000007100900400000030060001086000420` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as easy with score 127. |
| mastery_025 | 30 | hard | easy | 127 | 52 | hidden_single, naked_pair, naked_single | `010000000006050031800900000700805016003020800500301400030046028001702000000530004` | Requires naked_pair; current rater classifies the puzzle as easy with score 127. |
| mastery_037 | 30 | hard | easy | 127 | 53 | hidden_single, naked_pair, naked_single | `000396000006000205100050600873001096501900000060000050008005000045730001000000564` | Requires naked_pair; current rater classifies the puzzle as easy with score 127. |
| mastery_060 | 30 | hard | easy | 127 | 52 | hidden_single, naked_single, pointing_pair | `005314900400006000090500100000000000054000029002057300800045003040960208000020410` | Requires pointing_pair; current rater classifies the puzzle as easy with score 127. |
| mastery_072 | 30 | hard | easy | 127 | 52 | hidden_pair, hidden_single, naked_single | `207000491030000702000700030000807300010306050003054007000000009372000040960100200` | Requires hidden_pair; current rater classifies the puzzle as easy with score 127. |
| mastery_075 | 30 | hard | easy | 127 | 52 | hidden_single, naked_pair, naked_single | `009000407070090050000706001000008500705460009890057010050010020008000006960300700` | Requires naked_pair; current rater classifies the puzzle as easy with score 127. |
| mastery_120 | 28 | hard | easy | 127 | 54 | hidden_single, naked_pair, naked_single | `050020004902060300746008000000000009000002560204700000027000003060001002130000850` | Requires naked_pair; current rater classifies the puzzle as easy with score 127. |
| mastery_170 | 30 | hard | easy | 127 | 54 | hidden_single, naked_pair, naked_single | `008005000715090002030020017673980000020003490000000006180507900000040200400000050` | Requires naked_pair; current rater classifies the puzzle as easy with score 127. |
| mastery_180 | 28 | hard | easy | 127 | 54 | hidden_single, naked_pair, naked_single | `000060009003008000849075060005000090000007005798016000000009007007053000924000050` | Requires naked_pair; current rater classifies the puzzle as easy with score 127. |
| mastery_236 | 28 | hard | easy | 127 | 55 | hidden_single, naked_pair, naked_single | `190500040005002090200390005000750000000089030002000407000600804070020500000478000` | Requires naked_pair; current rater classifies the puzzle as easy with score 127. |
| mastery_255 | 28 | hard | easy | 127 | 54 | hidden_single, naked_pair, naked_single | `090001060000302800260000500000204036600180200450700080000005070020900008009400000` | Requires naked_pair; current rater classifies the puzzle as easy with score 127. |
| mastery_259 | 28 | hard | easy | 127 | 54 | hidden_single, naked_pair, naked_single | `000849000000003206013600000000000564020050000006008302030002000150960000094080005` | Requires naked_pair; current rater classifies the puzzle as easy with score 127. |
| mastery_009 | 32 | hard | easy | 126 | 51 | hidden_single, naked_pair, naked_single | `700900150050870049040000700527300001000109027001000600070403900000001000900607804` | Requires naked_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_045 | 30 | hard | easy | 126 | 52 | hidden_single, naked_pair, naked_single | `000210900000009360080600000030850049000136205058000600400000892020300000000008407` | Requires naked_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_047 | 30 | hard | easy | 126 | 52 | hidden_single, naked_pair, naked_single | `483200719250070000010000000000004520005009006608000003070893065000040000000100930` | Requires naked_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_074 | 30 | hard | easy | 126 | 52 | hidden_single, naked_pair, naked_single | `014003007800090040700000000000000009508047300007000600301605200400381700600409003` | Requires naked_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_106 | 29 | hard | easy | 126 | 54 | hidden_pair, hidden_single, naked_pair, naked_single | `673450100002008670000000040804100060000000319010000004000370000000046985000000701` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_125 | 29 | hard | easy | 126 | 53 | hidden_single, naked_pair, naked_single | `070859020005300060204006000060030010000200000000685003000000470002000039350400106` | Requires naked_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_129 | 29 | hard | easy | 126 | 54 | hidden_single, naked_pair, naked_single | `000602010310009000400035079200807900500006030900000507000000000000974023004200100` | Requires naked_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_142 | 29 | hard | easy | 126 | 53 | hidden_single, naked_pair, naked_single | `600120080048009000100004000000841005070006048800000030001008063900000014050400009` | Requires naked_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_147 | 29 | hard | easy | 126 | 53 | hidden_single, naked_pair, naked_single | `008090700000208040040050001000001062269000080000600074000500307000000090713900406` | Requires naked_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_148 | 29 | hard | easy | 126 | 53 | hidden_single, naked_pair, naked_single | `000245090000000008169080500010600072000500800300704009590000080728009000001000005` | Requires naked_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_159 | 29 | hard | easy | 126 | 54 | hidden_single, naked_pair, naked_single | `000070000007200903000003081500008690000962370090000000015004230030007064008000010` | Requires naked_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_161 | 28 | hard | easy | 126 | 55 | hidden_single, naked_pair, naked_single | `375000000008503269000000000700000004450000106000350920800700000590012400000030700` | Requires naked_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_163 | 28 | hard | easy | 126 | 54 | hidden_single, naked_pair, naked_single | `050000680028000000000682940080100007000260500000090034490000050800000003002806010` | Requires naked_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_172 | 28 | hard | easy | 126 | 54 | hidden_pair, hidden_single, naked_single | `300500100000000290000293047000902485048000072000400000075004000000320050600000010` | Requires hidden_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_187 | 28 | hard | easy | 126 | 54 | hidden_single, naked_pair, naked_single | `001900805400860000080010000000000050210000070935608040602091000140000700000700090` | Requires naked_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_215 | 28 | hard | easy | 126 | 54 | hidden_pair, hidden_single, naked_single | `005000476760031800200070001080000710642000098000090000001002600000050100070000040` | Requires hidden_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_222 | 28 | hard | easy | 126 | 54 | hidden_single, naked_pair, naked_single | `870900600500801004904060700080000000400057000000180006738000005045000000200600300` | Requires naked_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_270 | 28 | hard | easy | 126 | 54 | hidden_pair, hidden_single, naked_single | `004510000000000500050687020916003000000000003780200090608700000500900002370000960` | Requires hidden_pair; current rater classifies the puzzle as easy with score 126. |
| mastery_012 | 32 | hard | easy | 125 | 52 | hidden_pair, hidden_single, naked_pair, naked_single, pointing_pair | `000830007408702006200695300740100000009000060601050400174000030902000004300000690` | Requires hidden_pair, naked_pair, pointing_pair; current rater classifies the puzzle as easy with score 125. |
| mastery_050 | 30 | hard | easy | 125 | 52 | hidden_single, naked_pair, naked_single | `008009100200000597000203000000060940820590001009000028300020009084300010010940000` | Requires naked_pair; current rater classifies the puzzle as easy with score 125. |
| mastery_080 | 29 | hard | easy | 125 | 53 | hidden_single, naked_pair, naked_single | `080190004070086000000000306002060000050900760703851040010509000000400608000010020` | Requires naked_pair; current rater classifies the puzzle as easy with score 125. |
| mastery_088 | 29 | hard | easy | 125 | 54 | hidden_pair, hidden_single, naked_pair, naked_single | `043001000000420000080750423005970000436005000002040080000000000100204030020600017` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as easy with score 125. |
| mastery_095 | 30 | hard | easy | 125 | 52 | hidden_single, naked_pair, naked_single | `000020050291000080360000209806010003120053000000087040083000905002300400000095000` | Requires naked_pair; current rater classifies the puzzle as easy with score 125. |
| mastery_098 | 29 | hard | easy | 125 | 53 | hidden_single, naked_pair, naked_single | `080000601000503270040900058802004005490300020100000009000000013700000080000825006` | Requires naked_pair; current rater classifies the puzzle as easy with score 125. |
| mastery_103 | 29 | hard | easy | 125 | 53 | hidden_single, naked_pair, naked_single | `060973020002000000700014000400002003600700000050000086083007062200000700970601030` | Requires naked_pair; current rater classifies the puzzle as easy with score 125. |
| mastery_194 | 28 | hard | easy | 125 | 54 | hidden_pair, hidden_single, naked_single | `501900024000407510000010030050000007209000300170060000010000000408100000900284070` | Requires hidden_pair; current rater classifies the puzzle as easy with score 125. |
| mastery_252 | 28 | hard | easy | 125 | 54 | hidden_single, naked_pair, naked_single | `000082600456000308000600071130000009500001480064000200000000500670000800000500092` | Requires naked_pair; current rater classifies the puzzle as easy with score 125. |
| mastery_032 | 30 | hard | easy | 124 | 52 | hidden_single, naked_pair, naked_single | `000800200070300094008057000009705010016930700800000003720460500600000027080000400` | Requires naked_pair; current rater classifies the puzzle as easy with score 124. |
| mastery_051 | 32 | hard | easy | 124 | 51 | hidden_single, naked_pair, naked_single | `007002005005010003800560907300000070002000109060031802000007300070123048030840000` | Requires naked_pair; current rater classifies the puzzle as easy with score 124. |
| mastery_059 | 30 | hard | easy | 124 | 52 | hidden_pair, hidden_single, naked_single | `000400003637090405100700090300600008070000100500104027062540000000301086000006000` | Requires hidden_pair; current rater classifies the puzzle as easy with score 124. |
| mastery_064 | 30 | hard | easy | 124 | 52 | hidden_single, naked_pair, naked_single | `284009306600420000001003840000070000063000097700040280010530008000000100806000700` | Requires naked_pair; current rater classifies the puzzle as easy with score 124. |
| mastery_122 | 29 | hard | easy | 124 | 54 | hidden_pair, hidden_single, naked_pair, naked_single | `046709000025000090903251000380000200007000000600000059009600070700002000400080925` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as easy with score 124. |
| mastery_189 | 28 | hard | easy | 124 | 54 | hidden_single, naked_pair, naked_single | `006804030058000607000000045009740013030900080800030000700410006000000000963000050` | Requires naked_pair; current rater classifies the puzzle as easy with score 124. |
| mastery_225 | 28 | hard | easy | 124 | 54 | hidden_single, naked_pair, naked_single | `003504178000001000000062005006000547320005000047000000002009700000007080001280030` | Requires naked_pair; current rater classifies the puzzle as easy with score 124. |
| mastery_243 | 28 | hard | easy | 124 | 54 | hidden_single, naked_pair, naked_single | `079000200000000879203000065000400007020896000500000000102000090094000000730004152` | Requires naked_pair; current rater classifies the puzzle as easy with score 124. |
| mastery_247 | 28 | hard | easy | 124 | 54 | hidden_single, naked_pair, naked_single | `000200649000000005049080301067010030000000007934000002400006008258043000000000010` | Requires naked_pair; current rater classifies the puzzle as easy with score 124. |
| mastery_267 | 28 | hard | easy | 124 | 54 | hidden_single, naked_pair, naked_single | `790000002800070005005400001009006100000010030070000286603100050010090000057000018` | Requires naked_pair; current rater classifies the puzzle as easy with score 124. |
| mastery_017 | 31 | hard | easy | 123 | 51 | hidden_single, naked_pair, naked_single | `009300002020968530503120000200006000600090243005000001002041000900000060000709305` | Requires naked_pair; current rater classifies the puzzle as easy with score 123. |
| mastery_043 | 30 | hard | easy | 123 | 52 | hidden_single, naked_pair, naked_single | `200009035400010007000800000008006500003178026020053700000062390304000002670000000` | Requires naked_pair; current rater classifies the puzzle as easy with score 123. |
| mastery_046 | 30 | hard | easy | 123 | 52 | hidden_single, naked_pair, naked_single | `420003001000045000703000502000000054001032008080450200007510020108000700000960005` | Requires naked_pair; current rater classifies the puzzle as easy with score 123. |
| mastery_127 | 29 | hard | easy | 123 | 53 | hidden_single, naked_pair, naked_single | `683900000074000836200000000000000008006090405002801300000459280120006050000002000` | Requires naked_pair; current rater classifies the puzzle as easy with score 123. |
| mastery_151 | 29 | hard | easy | 123 | 53 | hidden_single, naked_pair, naked_single | `030000000700030958500400000900700000080549007100680005070160080060008009000004601` | Requires naked_pair; current rater classifies the puzzle as easy with score 123. |
| mastery_165 | 28 | hard | easy | 123 | 54 | hidden_single, naked_pair, naked_single | `000039000017040000308000546000097400900000068000360000020100053700600002006000104` | Requires naked_pair; current rater classifies the puzzle as easy with score 123. |
| mastery_193 | 28 | hard | easy | 123 | 54 | hidden_single, naked_pair, naked_single | `100085006009000080000009741000004869000000000030900207890206000400003670200000090` | Requires naked_pair; current rater classifies the puzzle as easy with score 123. |
| mastery_231 | 28 | hard | easy | 123 | 54 | hidden_single, naked_pair, naked_single | `000034009000600000005800024000390008500042006009500002002000090058021000030900071` | Requires naked_pair; current rater classifies the puzzle as easy with score 123. |
| mastery_232 | 28 | hard | easy | 123 | 54 | hidden_single, naked_pair, naked_single | `000000507800005900000130000009610000005004000136508470008400000004090160070800050` | Requires naked_pair; current rater classifies the puzzle as easy with score 123. |
| mastery_234 | 28 | hard | easy | 123 | 54 | hidden_single, naked_pair, naked_single | `200070003004090100003500060000060800000000039309000247000830502750000300000050096` | Requires naked_pair; current rater classifies the puzzle as easy with score 123. |
| mastery_010 | 32 | hard | easy | 122 | 51 | hidden_single, naked_pair, naked_single | `700005000090004010051069020027300000000648070006002009100900640030000051204500308` | Requires naked_pair; current rater classifies the puzzle as easy with score 122. |
| mastery_015 | 31 | hard | easy | 122 | 52 | hidden_single, naked_pair, naked_single | `007009080428006500950000070000002040009081065004600390741003900005000400800000050` | Requires naked_pair; current rater classifies the puzzle as easy with score 122. |
| mastery_028 | 30 | hard | easy | 122 | 53 | hidden_pair, hidden_single, naked_pair, naked_single | `057100008000000413000600007090301005310806904000040100206008000089407020000000009` | Requires hidden_pair, naked_pair; current rater classifies the puzzle as easy with score 122. |
| mastery_030 | 30 | hard | easy | 122 | 52 | hidden_single, naked_pair, naked_single | `004000087000000100320080000080006900060000258009258040200870001708600320000005004` | Requires naked_pair; current rater classifies the puzzle as easy with score 122. |
| mastery_040 | 30 | hard | easy | 122 | 53 | hidden_single, naked_pair, naked_single | `075286900100507002060000000000090000000105203000362490007000050080900027010023000` | Requires naked_pair; current rater classifies the puzzle as easy with score 122. |
| mastery_140 | 29 | hard | easy | 122 | 53 | hidden_single, naked_pair, naked_single | `000009425000600001300502000004000002190050000500800079976001800000000907000706203` | Requires naked_pair; current rater classifies the puzzle as easy with score 122. |
| mastery_195 | 28 | hard | easy | 122 | 54 | hidden_single, naked_pair, naked_single | `608002500000005300000080074090000005200000010004000860813020009040000007062054100` | Requires naked_pair; current rater classifies the puzzle as easy with score 122. |
| mastery_238 | 28 | hard | easy | 122 | 54 | hidden_single, naked_pair, naked_single | `000920508005040000069000040092000080874009160000080000023000000508070001900000302` | Requires naked_pair; current rater classifies the puzzle as easy with score 122. |
| mastery_008 | 32 | hard | easy | 121 | 50 | hidden_single, naked_pair, naked_single | `906340000280069000000850960003000070008075001090130402001400005009000300300590700` | Requires naked_pair; current rater classifies the puzzle as easy with score 121. |
| mastery_035 | 30 | hard | easy | 121 | 52 | hidden_single, naked_pair, naked_single | `010007000200000005005690100063041002800060017040008603000920361600000000009030040` | Requires naked_pair; current rater classifies the puzzle as easy with score 121. |
| mastery_067 | 30 | hard | easy | 121 | 52 | hidden_single, naked_single, pointing_pair | `003000008000092030800401600208000000004603700005080940300725010001360000002000403` | Requires pointing_pair; current rater classifies the puzzle as easy with score 121. |
| mastery_143 | 29 | hard | easy | 121 | 53 | hidden_single, naked_pair, naked_single | `248000090705000004000028053492007010307500020000040070070190000010003000800000040` | Requires naked_pair; current rater classifies the puzzle as easy with score 121. |
| mastery_144 | 29 | hard | easy | 121 | 53 | hidden_single, naked_pair, naked_single | `090000000642090810000000037000000104000609370030504000078052003360070540000000080` | Requires naked_pair; current rater classifies the puzzle as easy with score 121. |
| mastery_158 | 28 | hard | easy | 121 | 54 | hidden_single, naked_pair, naked_single | `000010005000000760070208034802000000019000408657000093061075000000004000200600800` | Requires naked_pair; current rater classifies the puzzle as easy with score 121. |
| mastery_220 | 28 | hard | easy | 121 | 54 | hidden_single, naked_pair, naked_single | `000100970000006000085070200009000810800304605000007394000002060003000709510080000` | Requires naked_pair; current rater classifies the puzzle as easy with score 121. |
| mastery_005 | 33 | hard | easy | 120 | 50 | hidden_single, naked_pair, naked_single, pointing_pair | `090206040003750000062040700070502103601000000020160480046800900000021630000000870` | Requires naked_pair, pointing_pair; current rater classifies the puzzle as easy with score 120. |
| mastery_019 | 31 | hard | easy | 120 | 51 | hidden_single, naked_pair, naked_single | `109500038063410500050080401000000049080000003006090150607300000000200380000051070` | Requires naked_pair; current rater classifies the puzzle as easy with score 120. |
| mastery_071 | 30 | hard | easy | 120 | 52 | hidden_pair, hidden_single, naked_single | `600005070803690000005000006730001054901400600050000000587000412000004080204007000` | Requires hidden_pair; current rater classifies the puzzle as easy with score 120. |
| mastery_111 | 29 | hard | easy | 120 | 53 | hidden_single, naked_pair, naked_single | `603904200149007000000360000030070052091000000000603070217008000000000020960001500` | Requires naked_pair; current rater classifies the puzzle as easy with score 120. |
| mastery_141 | 29 | hard | easy | 120 | 53 | hidden_pair, hidden_single, naked_single | `700200100600005042000900000500000014100000830000402006037004680006320001010500700` | Requires hidden_pair; current rater classifies the puzzle as easy with score 120. |
| mastery_205 | 28 | hard | easy | 120 | 54 | hidden_single, naked_pair, naked_single | `020050900354001200000806004030000085702000000800900102083000020900072050000000001` | Requires naked_pair; current rater classifies the puzzle as easy with score 120. |
| mastery_213 | 28 | hard | easy | 120 | 54 | hidden_single, naked_pair, naked_single | `000167004100090300000005070000000035500006108800040207010000506348000009000900040` | Requires naked_pair; current rater classifies the puzzle as easy with score 120. |
| mastery_253 | 28 | hard | easy | 120 | 54 | hidden_single, naked_pair, naked_single | `000000023000041070057090400000002190810000050035000000000074200001020809520380000` | Requires naked_pair; current rater classifies the puzzle as easy with score 120. |
| mastery_016 | 31 | hard | easy | 119 | 51 | hidden_single, naked_pair, naked_single | `300078956000050000950100070080501002402080005000030007008012000043005000200007068` | Requires naked_pair; current rater classifies the puzzle as easy with score 119. |
| mastery_065 | 30 | hard | easy | 119 | 53 | hidden_single, naked_pair, naked_single | `000010000040506000703008000082060749974000000300000820030092060100730002200000370` | Requires naked_pair; current rater classifies the puzzle as easy with score 119. |
| mastery_073 | 30 | hard | easy | 119 | 52 | hidden_single, naked_pair, naked_single | `400006790020970803000400000000700000060259000734061000002047000300600050540008900` | Requires naked_pair; current rater classifies the puzzle as easy with score 119. |
| mastery_126 | 29 | hard | easy | 119 | 53 | hidden_single, naked_pair, naked_single | `000040080005007200042060079070431000004680050086000000000000000008756300013004060` | Requires naked_pair; current rater classifies the puzzle as easy with score 119. |
| mastery_182 | 28 | hard | easy | 119 | 54 | hidden_single, naked_pair, naked_single | `090003205200879000006000000003060400000007001010940030500700010380206000007038000` | Requires naked_pair; current rater classifies the puzzle as easy with score 119. |
| mastery_212 | 28 | hard | easy | 119 | 54 | hidden_single, naked_pair, naked_single | `001080704500003600900000002690207003750800400000006005000060007000300080000018540` | Requires naked_pair; current rater classifies the puzzle as easy with score 119. |
| mastery_027 | 30 | hard | easy | 118 | 52 | hidden_single, naked_pair, naked_single | `000000605703010020000020000000083170009006250670050080948001000037002040200800001` | Requires naked_pair; current rater classifies the puzzle as easy with score 118. |
| mastery_031 | 30 | hard | easy | 118 | 52 | hidden_single, naked_pair, naked_single | `000243600006851030320060010000000060000385200090000853000408900000000000003690075` | Requires naked_pair; current rater classifies the puzzle as easy with score 118. |
| mastery_036 | 30 | hard | easy | 118 | 52 | hidden_pair, hidden_single, naked_single | `320980000094070062015000800400702600000309008009840000000007005050690100100000080` | Requires hidden_pair; current rater classifies the puzzle as easy with score 118. |
| mastery_041 | 29 | hard | easy | 118 | 53 | hidden_single, naked_pair, naked_single | `012070008043100900600000000135000700026704000000350000000607013000000040760810002` | Requires naked_pair; current rater classifies the puzzle as easy with score 118. |
| mastery_057 | 30 | hard | easy | 118 | 52 | hidden_single, naked_pair, naked_single | `000079000705000000800302900002950004009100800471008090107000369000705000200003001` | Requires naked_pair; current rater classifies the puzzle as easy with score 118. |
| mastery_058 | 30 | hard | easy | 118 | 52 | hidden_single, naked_pair, naked_single | `004008020058210060010000800820060900060070080470005000040907053000000610000006098` | Requires naked_pair; current rater classifies the puzzle as easy with score 118. |
| mastery_061 | 30 | hard | easy | 118 | 52 | hidden_single, naked_pair, naked_single | `028060000400000000009030081013058069002009030000010028604080000080092000200076010` | Requires naked_pair; current rater classifies the puzzle as easy with score 118. |
| mastery_119 | 29 | hard | easy | 118 | 53 | hidden_single, naked_pair, naked_single | `600000842059000000200000900000300007400208610000000394100000438900003000030710069` | Requires naked_pair; current rater classifies the puzzle as easy with score 118. |
| mastery_261 | 28 | hard | easy | 118 | 54 | hidden_single, naked_pair, naked_single | `310000020000000039000090508000876400102000000080000903035004091020000700076000085` | Requires naked_pair; current rater classifies the puzzle as easy with score 118. |
| mastery_269 | 28 | hard | easy | 118 | 54 | hidden_single, naked_pair, naked_single | `000706005761802003000000000008005007030600004200903008180000006000000000040360182` | Requires naked_pair; current rater classifies the puzzle as easy with score 118. |
| mastery_011 | 32 | hard | easy | 117 | 50 | hidden_single, naked_pair, naked_single | `502360409004750000030910050000003045409607300000040020080030002005870130000005000` | Requires naked_pair; current rater classifies the puzzle as easy with score 117. |
| mastery_026 | 30 | hard | easy | 117 | 52 | hidden_single, naked_pair, naked_single | `000080040003009010010007950321746890000200000604008000089004060500000032000600009` | Requires naked_pair; current rater classifies the puzzle as easy with score 117. |
| mastery_063 | 30 | hard | easy | 117 | 52 | hidden_single, naked_pair, naked_single | `938647002700002000015000000000083060002000701069050003500000306003075000020090400` | Requires naked_pair; current rater classifies the puzzle as easy with score 117. |
| mastery_077 | 30 | hard | easy | 117 | 52 | hidden_single, naked_pair, naked_single | `080100063030005100100900258500000601700010080000098740000400007400371006000000020` | Requires naked_pair; current rater classifies the puzzle as easy with score 117. |
| mastery_130 | 29 | hard | easy | 117 | 53 | hidden_single, naked_pair, naked_single | `070000080025089104000004500000000000507093000040065290750000000006918400009000032` | Requires naked_pair; current rater classifies the puzzle as easy with score 117. |
| mastery_153 | 29 | hard | easy | 117 | 53 | hidden_single, naked_pair, naked_single | `408370910200000004619050000000000230700200605100090007000040009000100068000008740` | Requires naked_pair; current rater classifies the puzzle as easy with score 117. |
| mastery_014 | 32 | hard | easy | 116 | 50 | hidden_single, naked_pair, naked_single | `050980000700000098800102500000290751082000060000030020500003070030720100000450386` | Requires naked_pair; current rater classifies the puzzle as easy with score 116. |
| mastery_090 | 29 | hard | easy | 116 | 53 | hidden_single, naked_single, pointing_pair | `050000040647000108108000000000309000081560300002408000005000700023700965000000023` | Requires pointing_pair; current rater classifies the puzzle as easy with score 116. |
| mastery_093 | 29 | hard | easy | 116 | 53 | hidden_single, naked_pair, naked_single | `003081000040600032560200000076000000302010000054706308030000409005060000008905000` | Requires naked_pair; current rater classifies the puzzle as easy with score 116. |
| mastery_112 | 29 | hard | easy | 116 | 53 | hidden_single, naked_pair, naked_single | `897050600040300070000009400000480026600007000050600030006000001589040300004000805` | Requires naked_pair; current rater classifies the puzzle as easy with score 116. |
| mastery_242 | 28 | hard | easy | 116 | 54 | hidden_single, naked_pair, naked_single | `007049580000800000000076020040100200200050300006700840153620400000980000000001000` | Requires naked_pair; current rater classifies the puzzle as easy with score 116. |
| mastery_068 | 30 | hard | easy | 115 | 52 | hidden_single, naked_pair, naked_single | `000000719000060230803900604010608090000230047000000500080300000007046000146082000` | Requires naked_pair; current rater classifies the puzzle as easy with score 115. |
| mastery_094 | 29 | hard | easy | 115 | 53 | hidden_single, naked_pair, naked_single | `970050000002009005100300000009000000704508200000647000043000008208400050590082060` | Requires naked_pair; current rater classifies the puzzle as easy with score 115. |
| mastery_108 | 29 | hard | easy | 115 | 53 | hidden_single, naked_pair, naked_single | `000090500190027000000836410900000700050003000300640000800060051000910200019200040` | Requires naked_pair; current rater classifies the puzzle as easy with score 115. |
| mastery_175 | 28 | hard | easy | 115 | 54 | hidden_single, naked_pair, naked_single | `030794000028030000400026050002000900000000276140000000070000400014079008200000607` | Requires naked_pair; current rater classifies the puzzle as easy with score 115. |
| mastery_003 | 34 | hard | easy | 114 | 48 | hidden_pair, hidden_single, naked_single | `075000196000700408400000257002000009090502743030980005920050081300200004007100000` | Requires hidden_pair; current rater classifies the puzzle as easy with score 114. |
| mastery_018 | 31 | hard | easy | 113 | 51 | hidden_single, naked_pair, naked_single | `040057008908000257027000006800300000704080300030000902000003820003000009200600743` | Requires naked_pair; current rater classifies the puzzle as easy with score 113. |
| mastery_022 | 31 | hard | easy | 113 | 51 | hidden_single, naked_pair, naked_single | `010903050000007601000080320074602090001300000500708010020034178180009030000000000` | Requires naked_pair; current rater classifies the puzzle as easy with score 113. |
| mastery_049 | 30 | hard | easy | 113 | 52 | hidden_single, naked_pair, naked_single | `600000020983045000000600308000070600172000005800050210598700000000090000024301009` | Requires naked_pair; current rater classifies the puzzle as easy with score 113. |
| mastery_078 | 30 | hard | easy | 113 | 52 | hidden_single, naked_pair, naked_single | `700000900000006027000257040000730218000600370007028009019060700360800000000004050` | Requires naked_pair; current rater classifies the puzzle as easy with score 113. |
| mastery_100 | 29 | hard | easy | 113 | 53 | hidden_single, naked_pair, naked_single | `000050000897000100000009432050000300100000024402000580000310600560048010300500007` | Requires naked_pair; current rater classifies the puzzle as easy with score 113. |
| mastery_002 | 34 | hard | easy | 112 | 48 | hidden_pair, hidden_single, naked_single | `006002094030940050040006070400020900000380000089465012000600020290054100671200000` | Requires hidden_pair; current rater classifies the puzzle as easy with score 112. |

## Classification Mismatches

- mastery_001: stored difficulty hard does not match re-rated medium
- mastery_001: stored score 185 does not match re-rated 143
- mastery_002: stored difficulty hard does not match re-rated easy
- mastery_002: stored score 185 does not match re-rated 112
- mastery_003: stored difficulty hard does not match re-rated easy
- mastery_003: stored score 185 does not match re-rated 114
- mastery_004: stored difficulty hard does not match re-rated medium
- mastery_004: stored score 185 does not match re-rated 135
- mastery_005: stored difficulty hard does not match re-rated easy
- mastery_005: stored score 185 does not match re-rated 120
- mastery_006: stored difficulty hard does not match re-rated medium
- mastery_006: stored score 185 does not match re-rated 139
- mastery_007: stored difficulty hard does not match re-rated medium
- mastery_007: stored score 185 does not match re-rated 137
- mastery_008: stored difficulty hard does not match re-rated easy
- mastery_008: stored score 185 does not match re-rated 121
- mastery_009: stored difficulty hard does not match re-rated easy
- mastery_009: stored score 185 does not match re-rated 126
- mastery_010: stored difficulty hard does not match re-rated easy
- mastery_010: stored score 185 does not match re-rated 122
- mastery_011: stored difficulty hard does not match re-rated easy
- mastery_011: stored score 185 does not match re-rated 117
- mastery_012: stored difficulty hard does not match re-rated easy
- mastery_012: stored score 185 does not match re-rated 125
- mastery_013: stored difficulty hard does not match re-rated medium
- mastery_013: stored score 185 does not match re-rated 141
- mastery_014: stored difficulty hard does not match re-rated easy
- mastery_014: stored score 185 does not match re-rated 116
- mastery_015: stored difficulty hard does not match re-rated easy
- mastery_015: stored score 185 does not match re-rated 122
- mastery_016: stored difficulty hard does not match re-rated easy
- mastery_016: stored score 185 does not match re-rated 119
- mastery_017: stored difficulty hard does not match re-rated easy
- mastery_017: stored score 185 does not match re-rated 123
- mastery_018: stored difficulty hard does not match re-rated easy
- mastery_018: stored score 185 does not match re-rated 113
- mastery_019: stored difficulty hard does not match re-rated easy
- mastery_019: stored score 185 does not match re-rated 120
- mastery_020: stored difficulty hard does not match re-rated medium
- mastery_020: stored score 185 does not match re-rated 143
- mastery_021: stored difficulty hard does not match re-rated medium
- mastery_021: stored score 185 does not match re-rated 134
- mastery_022: stored difficulty hard does not match re-rated easy
- mastery_022: stored score 185 does not match re-rated 113
- mastery_023: stored difficulty hard does not match re-rated medium
- mastery_023: stored score 185 does not match re-rated 131
- mastery_024: stored difficulty hard does not match re-rated easy
- mastery_024: stored score 185 does not match re-rated 127
- mastery_025: stored difficulty hard does not match re-rated easy
- mastery_025: stored score 185 does not match re-rated 127
- mastery_026: stored difficulty hard does not match re-rated easy
- mastery_026: stored score 185 does not match re-rated 117
- mastery_027: stored difficulty hard does not match re-rated easy
- mastery_027: stored score 185 does not match re-rated 118
- mastery_028: stored difficulty hard does not match re-rated easy
- mastery_028: stored score 185 does not match re-rated 122
- mastery_029: stored difficulty hard does not match re-rated easy
- mastery_029: stored score 185 does not match re-rated 129
- mastery_030: stored difficulty hard does not match re-rated easy
- mastery_030: stored score 185 does not match re-rated 122
- mastery_031: stored difficulty hard does not match re-rated easy
- mastery_031: stored score 185 does not match re-rated 118
- mastery_032: stored difficulty hard does not match re-rated easy
- mastery_032: stored score 185 does not match re-rated 124
- mastery_033: stored difficulty hard does not match re-rated medium
- mastery_033: stored score 185 does not match re-rated 135
- mastery_034: stored difficulty hard does not match re-rated easy
- mastery_034: stored score 185 does not match re-rated 130
- mastery_035: stored difficulty hard does not match re-rated easy
- mastery_035: stored score 185 does not match re-rated 121
- mastery_036: stored difficulty hard does not match re-rated easy
- mastery_036: stored score 185 does not match re-rated 118
- mastery_037: stored difficulty hard does not match re-rated easy
- mastery_037: stored score 185 does not match re-rated 127
- mastery_038: stored difficulty hard does not match re-rated medium
- mastery_038: stored score 185 does not match re-rated 146
- mastery_039: stored difficulty hard does not match re-rated medium
- mastery_039: stored score 185 does not match re-rated 140
- mastery_040: stored difficulty hard does not match re-rated easy
- mastery_040: stored score 185 does not match re-rated 122
- mastery_041: stored difficulty hard does not match re-rated easy
- mastery_041: stored score 185 does not match re-rated 118
- mastery_042: stored difficulty hard does not match re-rated medium
- mastery_042: stored score 185 does not match re-rated 137
- mastery_043: stored difficulty hard does not match re-rated easy
- mastery_043: stored score 185 does not match re-rated 123
- mastery_044: stored difficulty hard does not match re-rated medium
- mastery_044: stored score 185 does not match re-rated 141
- mastery_045: stored difficulty hard does not match re-rated easy
- mastery_045: stored score 185 does not match re-rated 126
- mastery_046: stored difficulty hard does not match re-rated easy
- mastery_046: stored score 185 does not match re-rated 123
- mastery_047: stored difficulty hard does not match re-rated easy
- mastery_047: stored score 185 does not match re-rated 126
- mastery_048: stored difficulty hard does not match re-rated medium
- mastery_048: stored score 185 does not match re-rated 142
- mastery_049: stored difficulty hard does not match re-rated easy
- mastery_049: stored score 185 does not match re-rated 113
- mastery_050: stored difficulty hard does not match re-rated easy
- mastery_050: stored score 185 does not match re-rated 125
- mastery_051: stored difficulty hard does not match re-rated easy
- mastery_051: stored score 185 does not match re-rated 124
- mastery_052: stored difficulty hard does not match re-rated medium
- mastery_052: stored score 185 does not match re-rated 131
- mastery_053: stored difficulty hard does not match re-rated easy
- mastery_053: stored score 185 does not match re-rated 128
- mastery_054: stored difficulty hard does not match re-rated medium
- mastery_054: stored score 185 does not match re-rated 151
- mastery_055: stored difficulty hard does not match re-rated medium
- mastery_055: stored score 185 does not match re-rated 131
- mastery_056: stored difficulty hard does not match re-rated medium
- mastery_056: stored score 185 does not match re-rated 134
- mastery_057: stored difficulty hard does not match re-rated easy
- mastery_057: stored score 185 does not match re-rated 118
- mastery_058: stored difficulty hard does not match re-rated easy
- mastery_058: stored score 185 does not match re-rated 118
- mastery_059: stored difficulty hard does not match re-rated easy
- mastery_059: stored score 185 does not match re-rated 124
- mastery_060: stored difficulty hard does not match re-rated easy
- mastery_060: stored score 185 does not match re-rated 127
- mastery_061: stored difficulty hard does not match re-rated easy
- mastery_061: stored score 185 does not match re-rated 118
- mastery_062: stored difficulty hard does not match re-rated medium
- mastery_062: stored score 185 does not match re-rated 133
- mastery_063: stored difficulty hard does not match re-rated easy
- mastery_063: stored score 185 does not match re-rated 117
- mastery_064: stored difficulty hard does not match re-rated easy
- mastery_064: stored score 185 does not match re-rated 124
- mastery_065: stored difficulty hard does not match re-rated easy
- mastery_065: stored score 185 does not match re-rated 119
- mastery_066: stored difficulty hard does not match re-rated medium
- mastery_066: stored score 185 does not match re-rated 138
- mastery_067: stored difficulty hard does not match re-rated easy
- mastery_067: stored score 185 does not match re-rated 121
- mastery_068: stored difficulty hard does not match re-rated easy
- mastery_068: stored score 185 does not match re-rated 115
- mastery_069: stored difficulty hard does not match re-rated easy
- mastery_069: stored score 185 does not match re-rated 128
- mastery_070: stored difficulty hard does not match re-rated medium
- mastery_070: stored score 185 does not match re-rated 133
- mastery_071: stored difficulty hard does not match re-rated easy
- mastery_071: stored score 185 does not match re-rated 120
- mastery_072: stored difficulty hard does not match re-rated easy
- mastery_072: stored score 185 does not match re-rated 127
- mastery_073: stored difficulty hard does not match re-rated easy
- mastery_073: stored score 185 does not match re-rated 119
- mastery_074: stored difficulty hard does not match re-rated easy
- mastery_074: stored score 185 does not match re-rated 126
- mastery_075: stored difficulty hard does not match re-rated easy
- mastery_075: stored score 185 does not match re-rated 127
- mastery_076: stored difficulty hard does not match re-rated medium
- mastery_076: stored score 185 does not match re-rated 134
- mastery_077: stored difficulty hard does not match re-rated easy
- mastery_077: stored score 185 does not match re-rated 117
- mastery_078: stored difficulty hard does not match re-rated easy
- mastery_078: stored score 185 does not match re-rated 113
- mastery_079: stored difficulty hard does not match re-rated medium
- mastery_079: stored score 185 does not match re-rated 160
- mastery_080: stored difficulty hard does not match re-rated easy
- mastery_080: stored score 185 does not match re-rated 125
- mastery_081: stored difficulty hard does not match re-rated medium
- mastery_081: stored score 185 does not match re-rated 151
- mastery_082: stored difficulty hard does not match re-rated easy
- mastery_082: stored score 185 does not match re-rated 130
- mastery_083: stored difficulty hard does not match re-rated medium
- mastery_083: stored score 185 does not match re-rated 146
- mastery_084: stored difficulty hard does not match re-rated medium
- mastery_084: stored score 185 does not match re-rated 163
- mastery_085: stored difficulty hard does not match re-rated easy
- mastery_085: stored score 185 does not match re-rated 130
- mastery_086: stored difficulty hard does not match re-rated medium
- mastery_086: stored score 185 does not match re-rated 143
- mastery_087: stored difficulty hard does not match re-rated medium
- mastery_087: stored score 185 does not match re-rated 136
- mastery_088: stored difficulty hard does not match re-rated easy
- mastery_088: stored score 185 does not match re-rated 125
- mastery_089: stored difficulty hard does not match re-rated medium
- mastery_089: stored score 185 does not match re-rated 152
- mastery_090: stored difficulty hard does not match re-rated easy
- mastery_090: stored score 185 does not match re-rated 116
- mastery_091: stored difficulty hard does not match re-rated medium
- mastery_091: stored score 185 does not match re-rated 140
- mastery_092: stored difficulty hard does not match re-rated medium
- mastery_092: stored score 185 does not match re-rated 149
- mastery_093: stored difficulty hard does not match re-rated easy
- mastery_093: stored score 185 does not match re-rated 116
- mastery_094: stored difficulty hard does not match re-rated easy
- mastery_094: stored score 185 does not match re-rated 115
- mastery_095: stored difficulty hard does not match re-rated easy
- mastery_095: stored score 185 does not match re-rated 125
- mastery_096: stored difficulty hard does not match re-rated easy
- mastery_096: stored score 185 does not match re-rated 128
- mastery_097: stored difficulty hard does not match re-rated medium
- mastery_097: stored score 185 does not match re-rated 149
- mastery_098: stored difficulty hard does not match re-rated easy
- mastery_098: stored score 185 does not match re-rated 125
- mastery_099: stored difficulty hard does not match re-rated medium
- mastery_099: stored score 185 does not match re-rated 145
- mastery_100: stored difficulty hard does not match re-rated easy
- mastery_100: stored score 185 does not match re-rated 113
- mastery_101: stored difficulty hard does not match re-rated medium
- mastery_101: stored score 185 does not match re-rated 134
- mastery_102: stored difficulty hard does not match re-rated medium
- mastery_102: stored score 185 does not match re-rated 146
- mastery_103: stored difficulty hard does not match re-rated easy
- mastery_103: stored score 185 does not match re-rated 125
- mastery_104: stored difficulty hard does not match re-rated medium
- mastery_104: stored score 185 does not match re-rated 146
- mastery_105: stored difficulty hard does not match re-rated easy
- mastery_105: stored score 185 does not match re-rated 129
- mastery_106: stored difficulty hard does not match re-rated easy
- mastery_106: stored score 185 does not match re-rated 126
- mastery_107: stored difficulty hard does not match re-rated easy
- mastery_107: stored score 185 does not match re-rated 130
- mastery_108: stored difficulty hard does not match re-rated easy
- mastery_108: stored score 185 does not match re-rated 115
- mastery_109: stored difficulty hard does not match re-rated medium
- mastery_109: stored score 185 does not match re-rated 132
- mastery_110: stored difficulty hard does not match re-rated medium
- mastery_110: stored score 185 does not match re-rated 141
- mastery_111: stored difficulty hard does not match re-rated easy
- mastery_111: stored score 185 does not match re-rated 120
- mastery_112: stored difficulty hard does not match re-rated easy
- mastery_112: stored score 185 does not match re-rated 116
- mastery_113: stored difficulty hard does not match re-rated medium
- mastery_113: stored score 185 does not match re-rated 132
- mastery_114: stored difficulty hard does not match re-rated medium
- mastery_114: stored score 185 does not match re-rated 145
- mastery_115: stored difficulty hard does not match re-rated medium
- mastery_115: stored score 185 does not match re-rated 133
- mastery_116: stored difficulty hard does not match re-rated medium
- mastery_116: stored score 185 does not match re-rated 138
- mastery_117: stored difficulty hard does not match re-rated medium
- mastery_117: stored score 185 does not match re-rated 137
- mastery_118: stored difficulty hard does not match re-rated medium
- mastery_118: stored score 185 does not match re-rated 145
- mastery_119: stored difficulty hard does not match re-rated easy
- mastery_119: stored score 185 does not match re-rated 118
- mastery_120: stored difficulty hard does not match re-rated easy
- mastery_120: stored score 185 does not match re-rated 127
- mastery_121: stored difficulty hard does not match re-rated medium
- mastery_121: stored score 185 does not match re-rated 148
- mastery_122: stored difficulty hard does not match re-rated easy
- mastery_122: stored score 185 does not match re-rated 124
- mastery_123: stored difficulty hard does not match re-rated easy
- mastery_123: stored score 185 does not match re-rated 129
- mastery_124: stored difficulty hard does not match re-rated medium
- mastery_124: stored score 185 does not match re-rated 133
- mastery_125: stored difficulty hard does not match re-rated easy
- mastery_125: stored score 185 does not match re-rated 126
- mastery_126: stored difficulty hard does not match re-rated easy
- mastery_126: stored score 185 does not match re-rated 119
- mastery_127: stored difficulty hard does not match re-rated easy
- mastery_127: stored score 185 does not match re-rated 123
- mastery_128: stored difficulty hard does not match re-rated medium
- mastery_128: stored score 185 does not match re-rated 133
- mastery_129: stored difficulty hard does not match re-rated easy
- mastery_129: stored score 185 does not match re-rated 126
- mastery_130: stored difficulty hard does not match re-rated easy
- mastery_130: stored score 185 does not match re-rated 117
- mastery_131: stored difficulty hard does not match re-rated medium
- mastery_131: stored score 185 does not match re-rated 161
- mastery_132: stored difficulty hard does not match re-rated medium
- mastery_132: stored score 185 does not match re-rated 154
- mastery_133: stored difficulty hard does not match re-rated easy
- mastery_133: stored score 185 does not match re-rated 128
- mastery_134: stored difficulty hard does not match re-rated medium
- mastery_134: stored score 185 does not match re-rated 172
- mastery_135: stored difficulty hard does not match re-rated medium
- mastery_135: stored score 185 does not match re-rated 131
- mastery_136: stored difficulty hard does not match re-rated easy
- mastery_136: stored score 185 does not match re-rated 130
- mastery_137: stored difficulty hard does not match re-rated medium
- mastery_137: stored score 185 does not match re-rated 144
- mastery_138: stored difficulty hard does not match re-rated medium
- mastery_138: stored score 185 does not match re-rated 137
- mastery_139: stored difficulty hard does not match re-rated medium
- mastery_139: stored score 185 does not match re-rated 134
- mastery_140: stored difficulty hard does not match re-rated easy
- mastery_140: stored score 185 does not match re-rated 122
- mastery_141: stored difficulty hard does not match re-rated easy
- mastery_141: stored score 185 does not match re-rated 120
- mastery_142: stored difficulty hard does not match re-rated easy
- mastery_142: stored score 185 does not match re-rated 126
- mastery_143: stored difficulty hard does not match re-rated easy
- mastery_143: stored score 185 does not match re-rated 121
- mastery_144: stored difficulty hard does not match re-rated easy
- mastery_144: stored score 185 does not match re-rated 121
- mastery_145: stored difficulty hard does not match re-rated medium
- mastery_145: stored score 185 does not match re-rated 140
- mastery_146: stored difficulty hard does not match re-rated medium
- mastery_146: stored score 185 does not match re-rated 152
- mastery_147: stored difficulty hard does not match re-rated easy
- mastery_147: stored score 185 does not match re-rated 126
- mastery_148: stored difficulty hard does not match re-rated easy
- mastery_148: stored score 185 does not match re-rated 126
- mastery_149: stored difficulty hard does not match re-rated medium
- mastery_149: stored score 185 does not match re-rated 137
- mastery_150: stored difficulty hard does not match re-rated medium
- mastery_150: stored score 185 does not match re-rated 149
- mastery_151: stored difficulty hard does not match re-rated easy
- mastery_151: stored score 185 does not match re-rated 123
- mastery_152: stored difficulty hard does not match re-rated medium
- mastery_152: stored score 185 does not match re-rated 156
- mastery_153: stored difficulty hard does not match re-rated easy
- mastery_153: stored score 185 does not match re-rated 117
- mastery_154: stored difficulty hard does not match re-rated medium
- mastery_154: stored score 185 does not match re-rated 179
- mastery_155: stored difficulty hard does not match re-rated medium
- mastery_155: stored score 185 does not match re-rated 133
- mastery_156: stored difficulty hard does not match re-rated medium
- mastery_156: stored score 185 does not match re-rated 135
- mastery_157: stored difficulty hard does not match re-rated medium
- mastery_157: stored score 185 does not match re-rated 134
- mastery_158: stored difficulty hard does not match re-rated easy
- mastery_158: stored score 185 does not match re-rated 121
- mastery_159: stored difficulty hard does not match re-rated easy
- mastery_159: stored score 185 does not match re-rated 126
- mastery_160: stored difficulty hard does not match re-rated medium
- mastery_160: stored score 185 does not match re-rated 146
- mastery_161: stored difficulty hard does not match re-rated easy
- mastery_161: stored score 185 does not match re-rated 126
- mastery_162: stored difficulty hard does not match re-rated medium
- mastery_162: stored score 185 does not match re-rated 133
- mastery_163: stored difficulty hard does not match re-rated easy
- mastery_163: stored score 185 does not match re-rated 126
- mastery_164: stored difficulty hard does not match re-rated medium
- mastery_164: stored score 185 does not match re-rated 160
- mastery_165: stored difficulty hard does not match re-rated easy
- mastery_165: stored score 185 does not match re-rated 123
- mastery_166: stored difficulty hard does not match re-rated easy
- mastery_166: stored score 185 does not match re-rated 130
- mastery_167: stored difficulty hard does not match re-rated medium
- mastery_167: stored score 185 does not match re-rated 131
- mastery_168: stored difficulty hard does not match re-rated medium
- mastery_168: stored score 185 does not match re-rated 134
- mastery_169: stored difficulty hard does not match re-rated medium
- mastery_169: stored score 185 does not match re-rated 131
- mastery_170: stored difficulty hard does not match re-rated easy
- mastery_170: stored score 185 does not match re-rated 127
- mastery_171: stored difficulty hard does not match re-rated medium
- mastery_171: stored score 185 does not match re-rated 131
- mastery_172: stored difficulty hard does not match re-rated easy
- mastery_172: stored score 185 does not match re-rated 126
- mastery_173: stored difficulty hard does not match re-rated medium
- mastery_173: stored score 185 does not match re-rated 134
- mastery_174: stored difficulty hard does not match re-rated medium
- mastery_174: stored score 185 does not match re-rated 150
- mastery_175: stored difficulty hard does not match re-rated easy
- mastery_175: stored score 185 does not match re-rated 115
- mastery_176: stored difficulty hard does not match re-rated easy
- mastery_176: stored score 185 does not match re-rated 130
- mastery_177: stored difficulty hard does not match re-rated easy
- mastery_177: stored score 185 does not match re-rated 129
- mastery_178: stored difficulty hard does not match re-rated medium
- mastery_178: stored score 185 does not match re-rated 139
- mastery_179: stored difficulty hard does not match re-rated easy
- mastery_179: stored score 185 does not match re-rated 129
- mastery_180: stored difficulty hard does not match re-rated easy
- mastery_180: stored score 185 does not match re-rated 127
- mastery_181: stored difficulty hard does not match re-rated medium
- mastery_181: stored score 185 does not match re-rated 134
- mastery_182: stored difficulty hard does not match re-rated easy
- mastery_182: stored score 185 does not match re-rated 119
- mastery_183: stored difficulty hard does not match re-rated medium
- mastery_183: stored score 185 does not match re-rated 137
- mastery_184: stored difficulty hard does not match re-rated medium
- mastery_184: stored score 185 does not match re-rated 142
- mastery_185: stored difficulty hard does not match re-rated easy
- mastery_185: stored score 185 does not match re-rated 129
- mastery_186: stored difficulty hard does not match re-rated medium
- mastery_186: stored score 185 does not match re-rated 131
- mastery_187: stored difficulty hard does not match re-rated easy
- mastery_187: stored score 185 does not match re-rated 126
- mastery_188: stored difficulty hard does not match re-rated medium
- mastery_188: stored score 185 does not match re-rated 160
- mastery_189: stored difficulty hard does not match re-rated easy
- mastery_189: stored score 185 does not match re-rated 124
- mastery_190: stored difficulty hard does not match re-rated medium
- mastery_190: stored score 185 does not match re-rated 136
- mastery_191: stored difficulty hard does not match re-rated medium
- mastery_191: stored score 185 does not match re-rated 155
- mastery_192: stored difficulty hard does not match re-rated medium
- mastery_192: stored score 185 does not match re-rated 165
- mastery_193: stored difficulty hard does not match re-rated easy
- mastery_193: stored score 185 does not match re-rated 123
- mastery_194: stored difficulty hard does not match re-rated easy
- mastery_194: stored score 185 does not match re-rated 125
- mastery_195: stored difficulty hard does not match re-rated easy
- mastery_195: stored score 185 does not match re-rated 122
- mastery_196: stored difficulty hard does not match re-rated medium
- mastery_196: stored score 185 does not match re-rated 148
- mastery_197: stored difficulty hard does not match re-rated medium
- mastery_197: stored score 185 does not match re-rated 133
- mastery_198: stored difficulty hard does not match re-rated medium
- mastery_198: stored score 185 does not match re-rated 131
- mastery_199: stored difficulty hard does not match re-rated medium
- mastery_199: stored score 185 does not match re-rated 134
- mastery_200: stored difficulty hard does not match re-rated medium
- mastery_200: stored score 185 does not match re-rated 131
- mastery_201: stored difficulty hard does not match re-rated easy
- mastery_201: stored score 185 does not match re-rated 129
- mastery_202: stored difficulty hard does not match re-rated medium
- mastery_202: stored score 185 does not match re-rated 139
- mastery_203: stored difficulty hard does not match re-rated medium
- mastery_203: stored score 185 does not match re-rated 138
- mastery_204: stored difficulty hard does not match re-rated medium
- mastery_204: stored score 185 does not match re-rated 157
- mastery_205: stored difficulty hard does not match re-rated easy
- mastery_205: stored score 185 does not match re-rated 120
- mastery_206: stored difficulty hard does not match re-rated medium
- mastery_206: stored score 185 does not match re-rated 135
- mastery_207: stored difficulty hard does not match re-rated medium
- mastery_207: stored score 185 does not match re-rated 145
- mastery_208: stored difficulty hard does not match re-rated medium
- mastery_208: stored score 185 does not match re-rated 131
- mastery_209: stored difficulty hard does not match re-rated medium
- mastery_209: stored score 185 does not match re-rated 163
- mastery_210: stored score 185 does not match re-rated 181
- mastery_211: stored difficulty hard does not match re-rated medium
- mastery_211: stored score 185 does not match re-rated 152
- mastery_212: stored difficulty hard does not match re-rated easy
- mastery_212: stored score 185 does not match re-rated 119
- mastery_213: stored difficulty hard does not match re-rated easy
- mastery_213: stored score 185 does not match re-rated 120
- mastery_214: stored difficulty hard does not match re-rated medium
- mastery_214: stored score 185 does not match re-rated 150
- mastery_215: stored difficulty hard does not match re-rated easy
- mastery_215: stored score 185 does not match re-rated 126
- mastery_216: stored difficulty hard does not match re-rated medium
- mastery_216: stored score 185 does not match re-rated 149
- mastery_217: stored difficulty hard does not match re-rated easy
- mastery_217: stored score 185 does not match re-rated 129
- mastery_218: stored difficulty hard does not match re-rated medium
- mastery_218: stored score 185 does not match re-rated 131
- mastery_219: stored difficulty hard does not match re-rated easy
- mastery_219: stored score 185 does not match re-rated 129
- mastery_220: stored difficulty hard does not match re-rated easy
- mastery_220: stored score 185 does not match re-rated 121
- mastery_221: stored difficulty hard does not match re-rated medium
- mastery_221: stored score 185 does not match re-rated 149
- mastery_222: stored difficulty hard does not match re-rated easy
- mastery_222: stored score 185 does not match re-rated 126
- mastery_223: stored difficulty hard does not match re-rated easy
- mastery_223: stored score 185 does not match re-rated 128
- mastery_224: stored difficulty hard does not match re-rated medium
- mastery_224: stored score 185 does not match re-rated 134
- mastery_225: stored difficulty hard does not match re-rated easy
- mastery_225: stored score 185 does not match re-rated 124
- mastery_226: stored difficulty hard does not match re-rated medium
- mastery_226: stored score 185 does not match re-rated 167
- mastery_227: stored difficulty hard does not match re-rated easy
- mastery_227: stored score 185 does not match re-rated 128
- mastery_228: stored difficulty hard does not match re-rated medium
- mastery_228: stored score 185 does not match re-rated 133
- mastery_229: stored difficulty hard does not match re-rated medium
- mastery_229: stored score 185 does not match re-rated 141
- mastery_230: stored difficulty hard does not match re-rated medium
- mastery_230: stored score 185 does not match re-rated 139
- mastery_231: stored difficulty hard does not match re-rated easy
- mastery_231: stored score 185 does not match re-rated 123
- mastery_232: stored difficulty hard does not match re-rated easy
- mastery_232: stored score 185 does not match re-rated 123
- mastery_233: stored difficulty hard does not match re-rated medium
- mastery_233: stored score 185 does not match re-rated 132
- mastery_234: stored difficulty hard does not match re-rated easy
- mastery_234: stored score 185 does not match re-rated 123
- mastery_235: stored difficulty hard does not match re-rated easy
- mastery_235: stored score 185 does not match re-rated 128
- mastery_236: stored difficulty hard does not match re-rated easy
- mastery_236: stored score 185 does not match re-rated 127
- mastery_237: stored difficulty hard does not match re-rated easy
- mastery_237: stored score 185 does not match re-rated 129
- mastery_238: stored difficulty hard does not match re-rated easy
- mastery_238: stored score 185 does not match re-rated 122
- mastery_239: stored difficulty hard does not match re-rated medium
- mastery_239: stored score 185 does not match re-rated 132
- mastery_240: stored difficulty hard does not match re-rated medium
- mastery_240: stored score 185 does not match re-rated 139
- mastery_241: stored difficulty hard does not match re-rated medium
- mastery_241: stored score 185 does not match re-rated 149
- mastery_242: stored difficulty hard does not match re-rated easy
- mastery_242: stored score 185 does not match re-rated 116
- mastery_243: stored difficulty hard does not match re-rated easy
- mastery_243: stored score 185 does not match re-rated 124
- mastery_244: stored difficulty hard does not match re-rated easy
- mastery_244: stored score 185 does not match re-rated 129
- mastery_245: stored difficulty hard does not match re-rated medium
- mastery_245: stored score 185 does not match re-rated 132
- mastery_246: stored difficulty hard does not match re-rated easy
- mastery_246: stored score 185 does not match re-rated 128
- mastery_247: stored difficulty hard does not match re-rated easy
- mastery_247: stored score 185 does not match re-rated 124
- mastery_248: stored difficulty hard does not match re-rated medium
- mastery_248: stored score 185 does not match re-rated 131
- mastery_249: stored difficulty hard does not match re-rated medium
- mastery_249: stored score 185 does not match re-rated 144
- mastery_250: stored difficulty hard does not match re-rated medium
- mastery_250: stored score 185 does not match re-rated 137
- mastery_251: stored difficulty hard does not match re-rated medium
- mastery_251: stored score 185 does not match re-rated 133
- mastery_252: stored difficulty hard does not match re-rated easy
- mastery_252: stored score 185 does not match re-rated 125
- mastery_253: stored difficulty hard does not match re-rated easy
- mastery_253: stored score 185 does not match re-rated 120
- mastery_254: stored difficulty hard does not match re-rated medium
- mastery_254: stored score 185 does not match re-rated 139
- mastery_255: stored difficulty hard does not match re-rated easy
- mastery_255: stored score 185 does not match re-rated 127
- mastery_256: stored difficulty hard does not match re-rated medium
- mastery_256: stored score 185 does not match re-rated 131
- mastery_257: stored difficulty hard does not match re-rated medium
- mastery_257: stored score 185 does not match re-rated 168
- mastery_258: stored difficulty hard does not match re-rated medium
- mastery_258: stored score 185 does not match re-rated 161
- mastery_259: stored difficulty hard does not match re-rated easy
- mastery_259: stored score 185 does not match re-rated 127
- mastery_260: stored difficulty hard does not match re-rated medium
- mastery_260: stored score 185 does not match re-rated 134
- mastery_261: stored difficulty hard does not match re-rated easy
- mastery_261: stored score 185 does not match re-rated 118
- mastery_262: stored difficulty hard does not match re-rated medium
- mastery_262: stored score 185 does not match re-rated 140
- mastery_263: stored difficulty hard does not match re-rated medium
- mastery_263: stored score 185 does not match re-rated 139
- mastery_264: stored difficulty hard does not match re-rated medium
- mastery_264: stored score 185 does not match re-rated 133
- mastery_265: stored difficulty hard does not match re-rated medium
- mastery_265: stored score 185 does not match re-rated 157
- mastery_266: stored difficulty hard does not match re-rated medium
- mastery_266: stored score 185 does not match re-rated 134
- mastery_267: stored difficulty hard does not match re-rated easy
- mastery_267: stored score 185 does not match re-rated 124
- mastery_268: stored difficulty hard does not match re-rated medium
- mastery_268: stored score 185 does not match re-rated 137
- mastery_269: stored difficulty hard does not match re-rated easy
- mastery_269: stored score 185 does not match re-rated 118
- mastery_270: stored difficulty hard does not match re-rated easy
- mastery_270: stored score 185 does not match re-rated 126
