# 증폭 요인 (Amplifiers)

> **문서 코드**: `PNA` — 건수 · ID 범위는 [README §1](README.md#1-문서-지도)
> **원문**: [pain-points.md](pain-points.md) · [concurrent-workload.md](concurrent-workload.md)
> **연관**: [pain-points-root-causes.md](pain-points-root-causes.md) · [pain-points-impacts.md](pain-points-impacts.md)
> **작성일**: YYYY-MM-DD · **최종 개정**: YYYY-MM-DD

증폭 요인은 원인 자체는 아니지만 **비용을 곱하는 구조**만 추린 층이다. 규모 · 속도 · 사람 의존 · 관계자 수처럼 원인이 같아도 손실을 몇 배로 키우는 조건을 적는다.

```mermaid
graph LR
    PNR["PNR 근본 원인<br/>(제거 대상)"] --> PNA["PNA 증폭 요인<br/>(배가 구조)"]
    PNA --> PNI["PNI 결과 손실<br/>(측정 지점)"]
    style PNA fill:#1f6feb,color:#fff,stroke-width:3px
```

---

<!-- 카테고리 양식 — root-causes 와 같다.

## PNA-1xx · <명사구> — "<별칭>"

| ID | 증폭 요인 | 출처 |
| --- | --- | --- |
| PNA-101 | <무엇이 비용을 곱하는가 — 수치 **굵게**> | `PNP-00n` · `FDW-00n` |

**핵심**: <한 줄>

**대응 REQ**

| Pain Point | 대응 REQ |
| --- | --- |
| PNA-101 | — |
-->

<!-- 예시(회의실 예약):
## PNA-1xx · 몰리는 시간대 — "월요일 아침에 다 잡는다"

| ID | 증폭 요인 | 출처 |
| --- | --- | --- |
| PNA-101 | 주간 회의 예약이 월요일 09시 전후 **30분 안에** 몰린다 | `PNP-002` · `FDW-001` |
-->

---

## 증폭 배율의 근거

[concurrent-workload.md](concurrent-workload.md)의 동시 처리 업무가 핵심 흐름 위에 어떻게 얹히는지다.

| 핵심 흐름 | 동시에 얹히는 업무 | 배율 근거 |
| --- | --- | --- |

---

## 미대응 Pain Point

<단계 8에서 채운다>

---

요약 : <어떤 증폭이 규모가 커질수록 더 커지고, 어떤 것을 시스템이 대체할 수 있는가 한 줄>
