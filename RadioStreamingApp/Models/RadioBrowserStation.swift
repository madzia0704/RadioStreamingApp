//
//  RadioBrowserStation.swift
//  RadioStreamingApp
//
//  Created by Magdalena Popińska on 05/08/2025.
//

struct RadioBrowserStation: Decodable {
    let stationuuid: String
    let name: String
    let url_resolved: String
    let favicon: String?
    let state: String?
    let tags: String
}
