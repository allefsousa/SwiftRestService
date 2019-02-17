//
//  ViewController.swift
//  Precobit
//
//  Created by Allef Sousa Santos on 17/02/19.
//  Copyright © 2019 Allef Sousa Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func updatePreco(_ sender: Any) {
        self.recuperarPrecoBitcoin()
    }
    @IBOutlet weak var labelPreco: UILabel!
    @IBOutlet weak var preco: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        self.recuperarPrecoBitcoin()
    }
    
    func formatterPreco(preco:NSNumber) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt_BR")
        if let precoFinal = nf.string(from: preco){
            return precoFinal
        }
        return "0,00"
    }
    
    func recuperarPrecoBitcoin(){
        
        
        self.preco.setTitle("Atualizando .......", for: .normal)
        
        if let url = URL(string: "https://blockchain.info/ticker"){
            // tarefa para consultar o serviço executada em uma thread diferente
            let tarefa = URLSession.shared.dataTask(with: url){(dados,requisicao,erro) in
                
                if erro == nil{
                    print("Sucesso ao fazer consulta de preço")
                    if let dadosRetorno = dados{
                        
                        do{
                            if let objectJson = try JSONSerialization.jsonObject(with: dadosRetorno, options:[]) as? [String: Any]{
                                
                                if let blr = objectJson["BRL"] as? [String:Any]{
                                    if let pree = blr["buy"] as? Double{
                                        let precoFomatado = self.formatterPreco(preco: NSNumber(value:pree))
                                       
                                        /// atualizando a main Theread
                                        DispatchQueue.main.sync(execute: {
                                              self.labelPreco.text = "R$" + precoFomatado
                                            self.preco.setTitle("Atualizar", for: .normal)

                                                })
                                        
                                      
                                        
                                    }
                                    
                                    
                                }
                                
                            }
                            
                        }catch{
                            print("Erro ao formatar o retorno")
                            
                        }
                        
                    }
                    
                    
                }else{
                    print("Erro ao fazer consulta de preço")
                    
                }
                
            }
            tarefa.resume()
            
        }
    }


}

