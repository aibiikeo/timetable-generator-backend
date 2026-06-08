package com.example.timetablegenerator.domain.dto.response;

import java.util.List;

public record PublicTimetableFilterOptionsResponse(
        List<PublicFilterOptionResponse> faculties,
        List<PublicFilterOptionResponse> departments,
        List<PublicFilterOptionResponse> groups,
        List<PublicFilterOptionResponse> teachers,
        List<PublicFilterOptionResponse> rooms
) {
}
