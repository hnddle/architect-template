# 00.project-proposal — 원자료

> **문서 코드**: 없음 (원자료 보관 · 정리)
> **규칙**: [source-intake](../../.claude/rules/requirements-engineering/source-intake) (단계 0) → [product-definition](../../.claude/rules/requirements-engineering/product-definition) (단계 0.5, 소유자 기획서 · 새 제품일 때) → [requirements-pipeline](../../.claude/rules/requirements-engineering/requirements-pipeline) (단계 1~8)
> **다음 단계**: [../01.requirements/README.md](../01.requirements/README.md)

원자료 폴더는 현업이 넘긴 자료를 **고치지 않고 보관**하고, 그 자료를 사실 · 판단 · 질문으로 나눈 **정리 문서 세 종류**를 두는 곳이다. 요구 계층(`01.requirements`)은 이 폴더의 정리 문서만 근거로 인용한다. 해결 방법은 여기서 쓰지 않는다.

## 1. 무엇을 넣는가

| 원자료 | 넣는 방식 | 파일 이름 |
| --- | --- | --- |
| 원문 문서 | 원본 그대로 | 받은 이름 |
| 기존 시스템 · 참고 서비스 화면 캡처 | 번호를 붙여 넣는다 | `screen-01.png` ~ `screen-nn.png` |
| 업무 파일(엑셀 · CSV) | 원본 그대로. 개인정보 · 실제 금액은 가린 사본만 | 받은 이름 |
| 인터뷰 · 회의 메모 | 날짜 · 발화자 역할을 붙인다 | `interview-YYYY-MM-DD-<역할>.md` |
| 소유자 기획서 | 원본 그대로. 관찰 자료가 아니라 소유자 지시다 | 받은 이름 |
| 데스크 리서치(법령 · 데이터 이용 조건 · 경쟁 · 시장) | 사실마다 출처 URL · 기준일 | `research-<주제>.md` |

1. 원본은 고치지 않는다. 정리 문서가 원본을 인용한다.
2. 실제 고객의 개인정보 · 계좌 · 단가는 저장소에 넣지 않는다.
3. 잠금 파일(`~$*`) · `.DS_Store`는 커밋하지 않는다.
4. 소유자 기획서로 시작하면 기획서의 번호는 `기획 FR-nn` 처럼 접두를 붙여 인용하고, 확정된 결정은 `specs/DECISIONS.md` 의 `D-NNN` 으로 옮기며, 사용자 이야기는 `USR` 의 직접 입력이 된다(source-intake §1.1).

## 2. 정리 문서 세 종류

`_template-*.md`를 복사해 이름을 바꾸고 채운다. 양식 파일은 지우지 않는다.

| 정리 문서 | 양식 | 인용 표기 |
| --- | --- | --- |
| 원문 · 화면 관찰 정리 | [_template-source-overview.md](_template-source-overview.md) | `개요 §n` · 부록은 `원문 §n` · 화면은 `screen-nn` |
| 현행 업무 조사 | [_template-current-work-survey.md](_template-current-work-survey.md) | `조사 §n` · `조사 P-n` · `조사 Q-<주제>n` |
| 업무 데이터 파일 분석 | [_template-data-file-analysis.md](_template-data-file-analysis.md) | `데이터 §n` · `데이터 X-n` |

소유자 기획서 · 새 제품이면 정리 문서 다음에 제품 정의 [_template-product-definition.md](_template-product-definition.md)를 채운다(인용 표기 `정의 §n`). 정리 문서가 아니라 사실 위에서 사명 · 문제 단위 · MVP를 고르는 문서다.

<!-- 예시(회의실 예약): 원자료가 「예시회사 회의실 예약 규칙.docx」 · 「screen-01~screen-06(기존 예약 게시판 화면)」 · 「회의실 사용 대장.xlsx」라면 정리 문서는 `source-overview.md` · `current-work-survey.md` · `data-file-analysis.md` 세 개다. -->

## 3. 진행 체크리스트

- [ ] 원자료를 넣고 화면 캡처에 번호를 붙였다
- [ ] 원문 · 화면 관찰 정리 — 원문 전문 부록 · 이미지 참조 표 · 조사 항목 네 바구니
- [ ] 업무 데이터 파일 분석 — 열 사전 · 수식 전문 · 품질 문제 · 「가장 먼저 필요한 것」
- [ ] 현행 업무 조사 — 표본 크기 · As-Is · `P-n` · 고객사별 편차(개인 고객 서비스는 사용자 집단별 차이, 없으면 생략) · `Q-<주제>n`
- [ ] 소유자 기획서가 있으면 — 확정된 결정을 `D-NNN` 으로 옮겼고, 날짜가 있는 외부 사실에 출처 · 기준일을 붙였다
- [ ] 소유자 기획서 · 새 제품이면 — 제품 정의를 채우고 완료 검사를 통과했다
- [ ] 인용 표기명을 `../01.requirements/README.md` §4에 등록했다
- [ ] 받아야 할 자료를 `../01.requirements/todo.md` §4에 적었다

요약 : 이 폴더는 원본을 지키고 사실을 가두는 곳이며, 여기서 정리한 문서만 요구 계층의 근거가 된다.
