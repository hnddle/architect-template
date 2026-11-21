# 근본 원인 (Root Causes)

> **문서 코드**: `PNR` — 건수 · ID 범위는 [README §1](README.md#1-문서-지도)
> **원문**: [pain-points.md](pain-points.md)
> **연관**: [pain-points-amplifiers.md](pain-points-amplifiers.md) · [pain-points-impacts.md](pain-points-impacts.md)
> **작성일**: YYYY-MM-DD · **최종 개정**: YYYY-MM-DD

근본 원인은 페인포인트 서술에서 **"이것을 없애면 고통이 사라지는가"**에 예라고 답할 수 있는 요소만 추린 층이다. 증폭 요인(`PNA`) · 결과 손실(`PNI`)과 구분하며, 한 서술에 복수 원인이 섞여 있으면 행이 늘어난다.

```mermaid
graph LR
    PNR["PNR 근본 원인<br/>(제거 대상)"] --> PNA["PNA 증폭 요인<br/>(배가 구조)"]
    PNA --> PNI["PNI 결과 손실<br/>(측정 지점)"]
    style PNR fill:#1f6feb,color:#fff,stroke-width:3px
```

---

<!-- 카테고리 양식(파이프라인 단계 3). 정의 표는 3열 이상, 첫 칸이 ID다. 대응 REQ 표는 2열이라 정의로 세지 않는다.

## PNR-1xx · <"무엇의 무엇" 명사구> — "<별칭>"

| ID | Pain Point | 출처 |
| --- | --- | --- |
| PNR-101 | <원인 서술 — 실측 수치 **굵게**> | `PNP-00n` |

**핵심**: <이 카테고리가 하류에 미치는 영향 한 줄>

**대응 REQ** — 상세는 [user-requirements.md](user-requirements.md) 참조

| Pain Point | 대응 REQ |
| --- | --- |
| PNR-101 | — |
-->

<!-- 예시(회의실 예약):
## PNR-1xx · 예약 정보의 확인 수단 부재 — "빈 줄 알았다"

| ID | Pain Point | 출처 |
| --- | --- | --- |
| PNR-101 | 겹침을 막는 장치가 없어 같은 시간의 예약이 **하루 2~3건** 저장된다 | `PNP-002` |
-->

---

## 미대응 Pain Point

<단계 8에서 채운다. 없으면 "없음". 다른 결정이 먼저 필요하면 "없음 — 단, PNR-nxx는 용어 결정(Q-NNN)이 선행">

---

요약 : <원인 카테고리 사이의 인과 사슬 한 문장 — "PNR-1xx가 PNR-2xx의 직접 원인이고 …">
