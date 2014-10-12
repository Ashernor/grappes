class Cms
  include Mongoid::Document
  include Mongoid::Timestamps

  field :language, type: String
  field :title_sidebar_left, type: String, default: "Affinez votre recherche"
  field :travel_length, type: String, default: "Durée de vol"
  field :within_time, type: String, default: "Horaires"
  field :stopover, type: String, default: "Escales"
  field :excluded_companies, type: String, default: "Pays à exclure"
  field :excluded_countries, type: String, default: "Compagnie à exclure"
  field :moods, type: String, default: "Humeur"
  field :reset_fields, type: String, default: "Réinitialiser les filtres"
  field :from_price1, type: String, default: "à partir de"
  field :two_way_trip, type: String, default: "Aller retour"
  field :more, type: String, default: "En savoir +"
  field :first_block_test, type: String, default: "Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum<br/><br/>Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum"
  field :tag_line, type: String, default: "Voyagez<br/>sans pépins !"
  field :from_price2, type: String, default: "Vol à partir de"
  field :start_city, type: String, default: "Ville de départ"
  field :two_way_trip2, type: String, default: "Aller <span>Retour</span>"
  field :budget, type: String, default: "Budget"
  field :friends, type: String, default: "Amis"
  field :footer, type: String, default: ""
end