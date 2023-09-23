enum Status {
  /*
  * [Status.success] sự kiện được xảy ra sau khi request dữ liệu thành công
  * */
  success,
  /*
  * [Status.loading] sự kiện được xảy ra lần đầu tiên khi vào một màn hình
  * */
  loading,
  /*
  * [Status.loading] sự kiện được xảy ra lần đầu tiên khi vào một màn hình
  * */
  waiting,
  /*
  * [Status.errorInit] sự kiện được xảy ra lần đầu tiên khi vào một màn hình
  * nhưng các request đầu tiên đó bị lỗi
  * */
  errorInit,
  /*
  * [Status.error] sự kiện được xảy ra khi request của [Status.waiting]
  * không thành công
  * */
  error,

}
