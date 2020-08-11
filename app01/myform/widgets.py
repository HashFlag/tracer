from django.forms import RadioSelect


class ColorRadioSelect(RadioSelect):

    template_name = 'widgets/color_radio/radio.html'
    option_template_name = 'widgets/color_radio/radio_option.html'
    print("template_name:", template_name)
    print("option_template_name:", option_template_name)