//
//  HomeViewModel.swift
//  Ronaldo
//
//  Created by Doko Farras on 21/03/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class HomeViewModel {
    
    private let disposeBag = DisposeBag()
    private var isFetching = false
    private var nextURL: String? = "https://pokeapi.co/api/v2/pokemon?limit=10&offset=0"
    
    // MARK: - Output
    let pokemonList = BehaviorRelay<[PokemonListItem]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        guard let url = nextURL, !isFetching else { return }
        
        isFetching = true
        isLoading.accept(true)
        
        AF.request(url)
            .validate()
            .responseDecodable(of: PokemonListResponse.self) { response in
                switch response.result {
                case .success(let data):
                    let updatedList = self.pokemonList.value + data.results
                    self.pokemonList.accept(updatedList)
                    self.nextURL = data.next // Update pagination
                case .failure(let error):
                    print("Error fetching Pokemon data: \(error.localizedDescription)")
                }
                
                self.isFetching = false
                self.isLoading.accept(false)
            }
    }
}
