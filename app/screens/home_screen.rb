class HomeScreen < PMScreen
  title "ContatSolution"
  stylesheet HomeScreenStylesheet

  def on_load
    append(Potion::TextView, :hello_label).data = "You have #{ContactSolution.all.count} contact(s) on this phone."
  end
end