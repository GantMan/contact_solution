class HomeScreen < PMScreen
  title "ContatSolution"
  stylesheet HomeScreenStylesheet

  def on_load
    append(Potion::TextView, :hello_label)
  end
end