import random
from PIL import Image, ImageDraw, ImageFont, ImageFilter
_letter_cases = "abcdefghjkmnpqrstuvwxy"  # 小写字母，去除可能干扰的i，l，o，z
_upper_cases = _letter_cases.upper()  # 大写字母
_numbers = ''.join(map(str, range(3, 10)))  # 数字
init_chars = ''.join((_letter_cases, _upper_cases, _numbers))

# font_type = ImageFont.truetype('static/fonts/Monaco.ttf', 30)
def image_code(
        size=(120, 30),
        chars=init_chars,
        img_type="GIF",
        mode="RGB",
        bg_color=(255, 255, 255),
        fg_color=(0, 0, 255),
        font_size=20,
        font_type='static/fonts/bauhausef-demibold.otf',
        length=5,
        draw_lines=True,
        n_line=(1, 4),
        draw_points=True,
        point_chance=2
):
    """
    @todo: 生成验证码图片
    @param size: 图片的大小，格式（宽，高），默认为(90, 30)
    @param chars: 允许的字符集合，格式字符串
    @param img_type: 图片保存的格式，默认为GIF，可选的为GIF，JPEG，TIFF，PNG
    @param mode: 图片模式，默认为RGB
    @param bg_color: 背景颜色，默认为白色
    @param fg_color: 前景色，验证码字符颜色，默认为蓝色#0000FF
    @param font_size: 验证码字体大小
    @param font_type: 验证码字体，默认为 ae_AlArabiya.ttf
    @param length: 验证码字符个数
    @param draw_lines: 是否划干扰线
    @param n_lines: 干扰线的条数范围，格式元组，默认为(1, 2)，只有draw_lines为True时有效
    @param draw_points: 是否画干扰点
    @param point_chance: 干扰点出现的概率，大小范围[0, 100]
    @return: [0]: PIL Image实例
    @return: [1]: 验证码图片中的字符串
    """
    width, height = size
    img = Image.new(mode, size, bg_color)  # 创建图形
    draw = ImageDraw.Draw(img)  # 创建画笔

    def get_chars():
        """ 生成给定长度的字符串，反回列表格式 """
        return random.sample(chars, 1)[0]

    def get_color():
        """ 生成随机颜色 """
        return (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))

    def create_lines():
        """ 绘制干扰线（噪线） """
        line_num = random.randint(*n_line)  # 干扰线条数
        for i in range(line_num):
            # 起始点坐标
            begin = (random.randint(0, size[0]), random.randint(0, size[1]))
            # 结束点坐标
            end = (random.randint(0, size[0]), random.randint(0, size[1]))
            draw.line([begin, end], fill=get_color())

    def create_points():
        """ 绘制干扰点（噪点） """
        # 大小限制在[0, 100],省去了if else的复杂操作
        chance = min(100, max(0, int(point_chance)))
        for w in range(width):
            for h in range(width):
                tmp = random.randint(0, 100)
                if tmp > 100 - chance:
                    draw.point((w, h), fill=get_color())

    def create_strs():
        """ 绘制验证码字符 """
        font = ImageFont.truetype(font_type, font_size)
        char_list = []
        for i in range(length):
            char = get_chars()
            char_list.append(char)
            height = random.randint(1, 5)
            draw.text([18 * (i + 1), height], char, get_color(), font=font)

        char_code = ''.join(char_list)
        return char_code

    if draw_lines:
        create_lines()
    if draw_points:
        create_points()
    strs = create_strs()
    params = [
        1 - float(random.randint(1, 2)) / 100,
        0, 0, 0,
        1 - float(random.randint(1, 10)) / 100,
        float(random.randint(1, 2)) / 500,
        0.001,
        float(random.randint(1, 2)) / 500
    ]
    # img = img.transform(size, Image.PERSPECTIVE, params)  # 创建扭曲
    # img = img.filter(ImageFilter.EDGE_ENHANCE_MORE)  # 滤镜，边界加强（阈值更大）
    return img, strs


if __name__ == "__main__":
    img, strs = image_code(size=(270, 90))
    with open('code.png', 'wb') as f:
        # save保存图片
        img.save(f, format='png')



