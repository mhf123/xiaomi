<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>图片上传</title>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="multipart/form-data; charset=utf-8" />

    <script type="text/javascript" src="../../js/jquery-3.3.1.js"></script>

    <style type="text/css">
        * {
            margin: 0;
            padding: 0;
        }

        #upBox {
            text-align: center;
            width: 500px;
            padding: 20px;
            border: 1px solid #666;
            margin: auto;
            margin-top: 150px;
            margin-bottom: 200px;
            position: relative;
            border-radius: 10px;
        }

        #inputBox {
            width: 100%;
            height: 40px;
            border: 1px solid cornflowerblue;
            color: cornflowerblue;
            border-radius: 20px;
            position: relative;
            text-align: center;
            line-height: 40px;
            overflow: hidden;
            font-size: 16px;
        }

        #inputBox input {
            width: 114%;
            height: 40px;
            opacity: 0;
            cursor: pointer;
            position: absolute;
            top: 0;
            left: -14%;

        }

        #imgBox {
            text-align: left;
        }

        .imgContainer {
            display: inline-block;
            width: 32%;
            height: 150px;
            margin-left: 1%;
            border: 1px solid #666666;
            position: relative;
            margin-top: 30px;
            box-sizing: border-box;
        }

        .imgContainer img {
            width: 100%;
            height: 150px;
            cursor: pointer;
        }

        .imgContainer p {
            position: absolute;
            bottom: -1px;
            left: 0;
            width: 100%;
            height: 30px;
            background: black;
            text-align: center;
            line-height: 30px;
            color: white;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            display: none;
        }

        .imgContainer:hover p {
            display: block;
        }

        #btn {
            outline: none;
            width: 100px;
            height: 30px;
            background: cornflowerblue;
            border: 1px solid cornflowerblue;
            color: white;
            cursor: pointer;
            margin-top: 30px;
            border-radius: 5px;
        }
    </style>


    <script>
        var imgSrc = []; //图片路径
        var imgFile = []; //文件流
        var imgName = []; //图片名字
        //选择图片
        function imgUpload(obj) {
            var oInput = '#' + obj.inputId;
            var imgBox = '#' + obj.imgBox;
            var btn = '#' + obj.buttonId;
            $(oInput).on("change", function () {
                var fileImg = $(oInput)[0];
                var fileList = fileImg.files;
                for (var i = 0; i < fileList.length; i++) {
                    var imgSrcI = getObjectURL(fileList[i]);
                    imgName.push(fileList[i].name);
                    imgSrc.push(imgSrcI);
                    imgFile.push(fileList[i]);
                }
                addNewContent(imgBox);

            })
            $(btn).on('click', function () {
                var formData = new FormData(document.getElementById());
                var data = new Object;
                data[obj.data] = imgFile;
                submitPicture(obj.upUrl, data);
            })
        }

        //图片展示
        function addNewContent(obj) {
            $(imgBox).html("");
            for (var a = 0; a < imgSrc.length; a++) {
                var oldBox = $(obj).html();
                $(obj).html(oldBox + '<div class="imgContainer"><img title=' + imgName[a] + ' alt=' + imgName[a] + ' src=' + imgSrc[a] + ' onclick="imgDisplay(this)"><p onclick="removeImg(this,' + a + ')" class="imgDelete">删除</p></div>');
            }
        }

        //删除
        function removeImg(obj, index) {
            imgSrc.splice(index, 1);
            imgFile.splice(index, 1);
            imgName.splice(index, 1);
            var boxId = "#" + $(obj).parent('.imgContainer').parent().attr("id");
            addNewContent(boxId);
        }

        //上传(将文件流数组传到后台)
        function submitPicture(url, data) {
            console.log(data);
            alert('请打开控制台查看传递参数！');
            if (url && data) {
                $.ajax({
                    type: "post",
                    url: url,
                    async: true,
                    data: data,
                    traditional: true,
                    processData: false,
                    contentType: false,
                    success: function (dat) {
                        //			console.log(dat);
                    },
                    dataType: 'JSON'
                });
            }
        }

        //图片灯箱
        function imgDisplay(obj) {
            var src = $(obj).attr("src");
            var imgHtml = '<div style="width: 100%;height: 100vh;overflow: auto;background: rgba(0,0,0,0.5);text-align: center;position: fixed;top: 0;left: 0;z-index: 1000;"><img src=' + src + ' style="margin-top: 100px;width: 70%;margin-bottom: 100px;"/><p style="font-size: 50px;position: fixed;top: 30px;right: 30px;color: white;cursor: pointer;" onclick="closePicture(this)">×</p></div>'
            $('body').append(imgHtml);
        }

        //关闭
        function closePicture(obj) {
            $(obj).parent("div").remove();
        }

        //图片预览路径
        function getObjectURL(file) {
            var url = null;
            if (window.createObjectURL != undefined) { // basic
                url = window.createObjectURL(file);
            } else if (window.URL != undefined) { // mozilla(firefox)
                url = window.URL.createObjectURL(file);
            } else if (window.webkitURL != undefined) { // webkit or chrome
                url = window.webkitURL.createObjectURL(file);
            }
            return url;
        }
    </script>


</head>
<body>

<form action="" method="post" enctype="multipart/form-data">
    <input type="file" name="file" multiple/>
    <input type="submit" value="图片上传">
</form>
<%--<div style="width: 100%;height: 100px;position: relative;">
    <div id="upBox">
        <div id="inputBox"><input type="file" title="请选择图片" id="file" multiple/>点击选择图片
        </div>
        <div id="imgBox">
        </div>
        <button id="btn">上传</button>
    </div>
</div>--%>

</body>
<script type="text/javascript">

    imgUpload({
        inputId: 'file', //input框id
        imgBox: 'imgBox', //图片容器id
        buttonId: 'btn', //提交按钮id
        upUrl: '/manager1/product/upload',  //提交地址
        data: 'file1' //参数名
    })

</script>
</html>
