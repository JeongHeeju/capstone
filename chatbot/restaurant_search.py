# restaurant_search.py
"""
식당 검색 및 결과 포맷팅 유틸리티
"""
import os
import logging
import requests
from typing import List, Dict, Tuple, Optional

# 환경 변수 (entrypoint에서 로드된 .env 활용)
KAKAO_REST_API_KEY = os.getenv("KAKAO_REST_API_KEY")

# 로거 설정
logger = logging.getLogger(__name__)


def get_coords_from_keyword(keyword: str) -> Tuple[Optional[float], Optional[float]]:
    """
    키워드(장소명)를 사용하여 카카오 로컬 API에서 위도(lat), 경도(lng)를 가져옵니다.

    Args:
        keyword: 검색할 장소 또는 키워드 문자열

    Returns:
        (lat, lng) 튜플. 실패 시 (None, None).
    """
    KAKAO_REST_API_KEY = os.getenv("KAKAO_REST_API_KEY")
    if not KAKAO_REST_API_KEY:
        logger.error("KAKAO_REST_API_KEY가 설정되지 않았습니다.")
        return None, None

    url = "https://dapi.kakao.com/v2/local/search/keyword.json"
    headers = {"Authorization": f"KakaoAK {KAKAO_REST_API_KEY}"}
    params = {"query": keyword}

    try:
        resp = requests.get(url, headers=headers, params=params, timeout=5)
        resp.raise_for_status()
        docs = resp.json().get("documents", [])
        if docs:
            return float(docs[0]["y"]), float(docs[0]["x"])
    except requests.RequestException:
        logger.exception("카카오 API에서 좌표 조회 실패")

    return None, None


def search_kakao_restaurants(
    query: str,
    lat: float,
    lng: float,
    radius: int,
    page: int = 1
) -> List[Dict[str, str]]:
    """
    카카오 로컬 키워드 검색 API를 통해 지정된 반경 내 식당을 검색합니다.

    Args:
        query: 검색할 키워드(예: '고기집')
        lat: 중심 위도
        lng: 중심 경도
        radius: 반경(m 단위)
        page: 페이지 번호(기본 1)

    Returns:
        식당 정보 딕셔너리 리스트. 각 딕셔너리는 다음 키를 포함합니다:
        - name: 식당명
        - address: 주소
        - phone: 전화번호
        - x, y: 위경도
        - map_image_url: 정적맵 이미지 요청 URL
    """
    KAKAO_REST_API_KEY = os.getenv("KAKAO_REST_API_KEY")
    if not KAKAO_REST_API_KEY:
        logger.error("KAKAO_REST_API_KEY가 설정되지 않았습니다.")
        return [{"error": "API 키 없음"}]

    url = "https://dapi.kakao.com/v2/local/search/keyword.json"
    headers = {"Authorization": f"KakaoAK {KAKAO_REST_API_KEY}"}
    params = {
        "query": query,
        "x": lng,
        "y": lat,
        "radius": radius,
        "category_group_code": "FD6",
        "size": 3,
        "page": page,
        "sort": "accuracy"
    }

    try:
        resp = requests.get(url, headers=headers, params=params, timeout=5)
        resp.raise_for_status()
        docs = resp.json().get("documents", [])

        places: List[Dict[str, str]] = []
        for r in docs:
            y = r.get("y")
            x = r.get("x")
            places.append({
                "name": r.get("place_name", ""),
                "address": r.get("road_address_name") or r.get("address_name", ""),
                "phone": r.get("phone", ""),
                "x": x,
                "y": y,
                "map_image_url": f"/api/proxy/map?lat={y}&lng={x}"
            })

        return places
    except requests.RequestException:
        logger.exception("카카오 API에서 식당 검색 실패")
        return [{"error": "식당 검색 실패"}]


def format_restaurant_info(places: List[Dict[str, str]]) -> str:
    """
    식당 정보 리스트를 마크다운 형식의 문자열로 변환합니다.

    Args:
        places: search_kakao_restaurants 반환값

    Returns:
        마크다운 리스트 문자열.
    """
    lines: List[str] = []
    for p in places:
        if "error" in p:
            return f"Error: {p['error']}"
        lines.append(
            f"- {p['name']}\n"
            f"  📞번호 | {p['phone']}\n"
            f"  🏠주소 | {p['address']}"
        )
    return "\n".join(lines)
