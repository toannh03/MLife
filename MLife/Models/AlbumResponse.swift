//
//  AlbumResponse.swift
//  MLife
//
//  Created by Nguyễn Hữu Toàn on 06/08/2022.
//

import Foundation

struct AlbumResponse: Codable {
    let _id: String
    let name: String
    let artists_name: String
    let thumbnail: URL?
    let songs: [Song]
}

/*
[
    {
    "_id": "626d83441829e0ae1d82885d",
    "name": "Đen Vâu",
    "artists_name": "Đen Vâu",
    "thumbnail": "https://i1.sndcdn.com/artworks-z2gxcCZamslfRFWy-mSu93g-t500x500.jpg",
    "createdAt": "2022-04-30T18:43:16.955Z",
    "updatedAt": "2022-04-30T18:43:16.955Z",
    "__v": 0,
    "songs": [
        {
            "_id": "62841b27fa8fe2fbb57563ef",
            "name_song": "Bài này Chill phết",
            "title": "Bài này Chill phết",
            "album_id": "626d83441829e0ae1d82885d",
            "playlist_id": "62562e2cd66f2ba5e0dbfc95",
            "artists": " Đen Vâu, Min",
            "thumbnail": "https://i.ytimg.com/vi/ddaEtFOsFeM/maxresdefault.jpg",
            "category_id": "626df59369bbbdaeba443b7b",
            "link": "https://firebasestorage.googleapis.com/v0/b/fir-fe0e1.appspot.com/o/Den%20Vau%2FBaiNayChillPhet-DenMIN-5978903.mp3?alt=media&token=650d16c8-1594-4bb9-a5be-bff0a7f5e28d",
            "like": "1",
            "createdAt": "2022-05-17T22:01:11.506Z",
            "updatedAt": "2022-05-17T22:01:11.506Z",
            "__v": 0
        },
        {
            "_id": "62841bb0fa8fe2fbb57563f1",
            "name_song": "Cho tôi lang thang",
            "title": "Bài hát của Ngọt và Đen Vâu",
            "album_id": "626d83441829e0ae1d82885d",
            "playlist_id": "62562e2cd66f2ba5e0dbfc95",
            "artists": " Đen Vâu, Ngọt",
            "thumbnail": "https://i1.sndcdn.com/artworks-000211366895-uuwkx0-t500x500.jpg",
            "category_id": "626df59369bbbdaeba443b7b",
            "link": "https://firebasestorage.googleapis.com/v0/b/fir-fe0e1.appspot.com/o/Den%20Vau%2FCho%20Toi%20Lang%20Thang%20-%20Ngot%20vc_%20Den%20-%20Ngot.mp3?alt=media&token=c6b3783a-4e1d-4447-9a67-9fbe26853832",
            "like": "100",
            "createdAt": "2022-05-17T22:03:28.307Z",
            "updatedAt": "2022-05-17T22:03:28.307Z",
            "__v": 0
        }
    ]
},
    {
    "_id": "6283fee0fa8fe2fbb575632f",
    "name": "Vũ.Mix",
    "artists_name": "Phan Mạnh Quỳnh, Vũ, Đen, JustaTee",
    "thumbnail": "https://i.scdn.co/image/ab67616d0000b2734eca4595da187b3a25eb9958",
    "createdAt": "2022-05-17T20:00:32.290Z",
    "updatedAt": "2022-05-17T20:00:32.290Z",
    "__v": 0,
    "songs": [
        {
            "_id": "626e3141f657dc9a1a2d9dae",
            "name_song": "Chạy về nơi phía anh",
            "title": "Chạy về nơi phía anh",
            "album_id": "6283fee0fa8fe2fbb575632f",
            "playlist_id": "62562be8d66f2ba5e0dbfc90",
            "artists": "Khắc Việt",
            "thumbnail": "https://avatar-ex-swe.nixcdn.com/song/share/2022/02/10/a/1/5/7/1644475458882.jpg",
            "category_id": "62372f9329613fbeefc6237b",
            "link": "https://firebasestorage.googleapis.com/v0/b/fir-fe0e1.appspot.com/o/ChayVeNoiPhiaAnh-KhacViet-7129688.mp3?alt=media&token=01d424de-8426-4241-a5f4-d581ca5e8ad2",
            "like": "0",
            "createdAt": "2022-05-01T07:05:37.289Z",
            "updatedAt": "2022-05-01T07:05:37.289Z",
            "__v": 0,
            "topic_id": "62372da55767593b3103049c"
        },
        {
            "_id": "62841db3c29596e217380e16",
            "name_song": "Chuyện những người yêu xa",
            "title": "Bài hát của Vũ",
            "album_id": "6283fee0fa8fe2fbb575632f",
            "playlist_id": "62562e2cd66f2ba5e0dbfc95",
            "artists": "Vũ",
            "thumbnail": "https://i1.sndcdn.com/artworks-000382952367-sd94v6-t500x500.jpg",
            "category_id": "626df59369bbbdaeba443b7b",
            "link": "https://firebasestorage.googleapis.com/v0/b/fir-fe0e1.appspot.com/o/Vu%2FChuyenNhungNguoiYeuXa-VU-6467584.mp3?alt=media&token=fdab067b-25d1-42f5-ace8-4c53106c946a",
            "like": "100",
            "createdAt": "2022-05-17T22:12:03.753Z",
            "updatedAt": "2022-05-17T22:12:03.753Z",
            "__v": 0
        }
    ]
}
*/
