// js上传文件
        function bindChangeFilePut() {
            $("#upload-files").change(function () {
                // 获取上传的文件
                checkFileList = []
                var files = $(this)[0].files;
                $.each(files, function (index, fileObject) {
                    checkFileList.push(
                        {name: fileObject.name, size: fileObject.size}
                    )
                });

                // 获取前端临时凭证的js部分
                $.post(GET_CREDENTIAL_URL, JSON.stringify(checkFileList), function (data) {
                    if (data.status) {
                        let client = new OSS({
                            region: 'oss-' + data.region,
                            //云账号AccessKey有所有API访问权限，建议遵循阿里云安全最佳实践，创建并使用STS方式来进行API访问
                            accessKeyId: data.AccessKeyId,
                            accessKeySecret: data.AccessKeySecret,
                            stsToken: data.SecurityToken,
                            bucket: data.bucket
                        });
                        let options = function progress(p, checkpoint) {
                            console.log(p);
                        }

                        // object表示上传到OSS的名字，可自己定义
                        // file浏览器中需要上传的文件，支持HTML5 file 和 Blob类型
                        $.each(files, function (index, fileObject) {
                            let trEle = $("#process-model").find('tr').clone();
                            var fileName = fileObject.name;
                            trEle.find(".name").text(fileName);
                            $("#process-list").append(trEle);
                            let filename = fileObject.name;

                            // 异步上传文件
                            client.put(filename, fileObject).then(function (r1) {
                                // client.multipartUpload(filename, fileObject, options).then(function (r1) {
                                console.log('put success: %j', r1);
                                // return client.get('123456789.jpg');  // 下载
                            }).catch(function (err) {
                                console.error('error: %j', err);
                            });
                        });

                        // 下载文件
                        /*
                        client.get('123456789.jpg').then(function (r1) {
                            console.log('get success: %j', r1);
                        }).catch(function (err) {
                            console.error('error: %j', err);
                        });*/
                    } else {
                        alert(data.error);
                        // alert("获取临时凭证失败！");
                    }
                });
            });
        }