# 02.prd — 제품 요구사항 정의서

> **문서 코드**: `PRD` — 건수는 [../01.requirements/README.md §1](../01.requirements/README.md#1-문서-지도)
> **규칙**: [prd-guide](../../.claude/rules/requirements-engineering/prd-guide) (정본) · 빈 문서 [prd-template](../../.claude/rules/requirements-engineering/prd-template)
> **상위**: [../01.requirements/user-requirements.md](../01.requirements/user-requirements.md) (`REQ`) · **하위**: [../03.srs/](../03.srs/srs_01_introduction.md)

PRD는 `REQ`를 **제품 기능 영역 → 기능(`PRD-n0m`) → 릴리스 범위**로 편성하고 성공 판정 기준을 숫자로 고정하는 문서다. 요구를 **만드는** 문서가 아니라 **묶고 순서를 매기는** 문서다. 이 README는 시작법만 적는다 — 규칙과 절별 양식의 정본은 `prd-guide`이고, 템플릿 본문은 `prd-template` 한 곳에만 있다.

## 1. 시작하는 법

1. **REQ 배분 표부터** — 스크래치에 `REQ | 카테고리 | 후보 영역 | 성격(내부/대면/시스템/범위 밖)` 표를 만들어 `REQ` 전건을 채운다. 여기서 영역이 결정된다(`prd-guide` §9.1).
2. **템플릿 복사** — `.claude/rules/requirements-engineering/prd-template`을 이 폴더에 `prd-v1.0.md`로 복사하고 `<>` 자리표시자를 채운다. 주석은 제출 전 지운다.
3. **단계마다 합의** — 문제 합의(§1~§4) → 솔루션 합의(§5~§8) → 실행(§7 수용 기준 · §9 · §3.3)(`prd-guide` §4). 1인 프로젝트면 머리 표 관련자에 겸임을 적는다.
4. **검증식** — §6.3 끝과 §13.1의 `검증식:` 줄을 채우고 `bash scripts/check-requirements.sh`로 REQ 총수와 맞춘다.
5. **되돌려 채우기** — `REQ` 문서의 `PRD 영역` 열과 부록 E, 요구 README §1의 `PRD` 건수를 갱신하고 CHANGELOG에 남긴다.

## 2. 버전 규칙

| 바뀌는 것 | 하는 일 | 파일 |
| --- | --- | --- |
| 기능 추가 · 범위 이동 · 결정 반영 | 머리 표 아래 개정 블록 한 줄 + §13.2 결정 로그 행 | 같은 파일(`prd-v1.0.md`), 버전 표기는 `V1.1`로 |
| §6.1 기능 영역 재편 | 새 파일 | `prd-v2.0.md` — 이전 파일은 지우지 않는다 |

개정 블록은 최신 세 줄만 머리에 두고 나머지는 §13.2로 내린다. 검사 스크립트는 이 폴더에서 이름 순으로 마지막 `prd-v*.md`를 현재 판으로 읽는다.

## 3. 진행 체크리스트

- [ ] REQ 배분 표 — 전건이 영역 1~n · 시스템 · 범위 밖 중 한 곳
- [ ] §1~§4 문제 합의 — §3 지표 3요소, 기준값이 없으면 「기준값 없음 처리」 블록
- [ ] §5~§8 솔루션 합의 — 원칙 5~7 · Non-goal 최소 1 · 사람 개입 영역
- [ ] §7 영역마다 6단 · 실패 처리 표에 중복 요청 = 멱등 행
- [ ] §9 gate · Deferred · 보류 표기 · 롤백 = 가드레일 지표
- [ ] §13.1 `검증식:` = REQ 부록 E = 요구 README §1 (스크립트 통과)

요약 : 배분 표가 맞기 전에는 §7을 쓰지 않고, 검증식이 맞기 전에는 완료로 치지 않는다.
