require 'gs2/core/AbstractClient.rb'

module Gs2 module Notification
  
  # GS2-Notification クライアント
  #
  # @author Game Server Services, Inc.
  class Client < Gs2::Core::AbstractClient
  
    @@ENDPOINT = 'notification'
  
    # コンストラクタ
    # 
    # @param region [String] リージョン名
    # @param gs2_client_id [String] GSIクライアントID
    # @param gs2_client_secret [String] GSIクライアントシークレット
    def initialize(region, gs2_client_id, gs2_client_secret)
      super(region, gs2_client_id, gs2_client_secret)
    end
    
    # デバッグ用。通常利用する必要はありません。
    def self.ENDPOINT(v = nil)
      if v
        @@ENDPOINT = v
      else
        return @@ENDPOINT
      end
    end

    # 通知リストを取得
    # 
    # @param pageToken [String] ページトークン
    # @param limit [Integer] 取得件数
    # @return [Array]
    #   * items
    #     [Array]
    #       * notificationId => 通知ID
    #       * ownerId => オーナーID
    #       * name => 通知名
    #       * description => 説明文
    #       * createAt => 作成日時
    #       * updateAt => 更新日時
    #   * nextPageToken => 次ページトークン
    def describe_notification(pageToken = nil, limit = nil)
      query = {}
      if pageToken; query['pageToken'] = pageToken; end
      if limit; query['limit'] = limit; end
      return get(
            'Gs2Notification', 
            'DescribeNotification', 
            @@ENDPOINT, 
            '/notification',
            query);
    end
    
    # 通知を作成<br>
    # <br>
    # 通知はGS2内で発生したイベントを受け取る手段を提供します。<br>
    # 例えば、GS2-Watch の監視データが一定の閾値を超えた時に通知する。といった用途に利用できます。<br>
    # <br>
    # GS2 のサービスの多くはクオータを買い、その範囲内でサービスを利用する形式が多く取られていますが、<br>
    # 現在の消費クオータが GS2-Watch で取れますので、クオータの消費量が予約量の80%を超えたら通知をだす。というような使い方ができます。<br>
    # 
    # @param request [Array]
    #   * name => 通知名
    #   * description => 説明文
    # @return [Array]
    #   * item
    #     * notificationId => 通知ID
    #     * ownerId => オーナーID
    #     * name => 通知名
    #     * description => 説明文
    #     * createAt => 作成日時
    #     * updateAt => 更新日時
    def create_notification(request)
      if not request; raise ArgumentError.new(); end
      body = {}
      if request.has_key?('name'); body['name'] = request['name']; end
      if request.has_key?('description'); body['description'] = request['description']; end
      query = {}
      return post(
            'Gs2Notification', 
            'CreateNotification', 
            @@ENDPOINT, 
            '/notification',
            body,
            query);
    end
  
    # 通知を取得
    #
    # @param request [Array]
    #   * notificationName => 通知名
    # @return [Array]
    #   * item
    #     * notificationId => 通知ID
    #     * ownerId => オーナーID
    #     * name => 通知名
    #     * description => 説明文
    #     * createAt => 作成日時
    #     * updateAt => 更新日時
    def get_notification(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('notificationName'); raise ArgumentError.new(); end
      if not request['notificationName']; raise ArgumentError.new(); end
      query = {}
      return get(
          'Gs2Notification',
          'GetNotification',
          @@ENDPOINT,
          '/notification/' + request['notificationName'],
          query);
    end
  
    # 通知を更新
    #
    # @param request [Array]
    #   * notificationName => 通知名
    #   * description => 説明文
    # @return [Array] 
    #   * item
    #     * notificationId => 通知ID
    #     * ownerId => オーナーID
    #     * name => 通知名
    #     * description => 説明文
    #     * createAt => 作成日時
    #     * updateAt => 更新日時
    def update_notification(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('notificationName'); raise ArgumentError.new(); end
      if not request['notificationName']; raise ArgumentError.new(); end
      body = {}
      if request.has_key?('description'); body['description'] = request['description']; end
      query = {}
      return put(
          'Gs2Notification',
          'UpdateNotification',
          @@ENDPOINT,
          '/notification/' + request['notificationName'],
          body,
          query);
    end
    
    # 通知を削除
    # 
    # @param request [Array]
    #   * notificationName => 通知名
    def delete_notification(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('notificationName'); raise ArgumentError.new(); end
      if not request['notificationName']; raise ArgumentError.new(); end
      query = {}
      return delete(
            'Gs2Notification', 
            'DeleteNotification', 
            @@ENDPOINT, 
            '/notification/' + request['notificationName'],
            query);
    end
    
    # 通知先リストを取得
    #
    # @param request [Array]
    #   * notificationName => 通知名
    # @param pageToken [String] ページトークン
    # @param limit [Integer] 取得件数
    # @return [Array]
    #   * items
    #     [Array]
    #       * subscribeId => 通知先ID
    #       * notificationId => 通知ID
    #       * type => 通知プロトコル
    #       * endpoint => 通知先
    #       * createAt => 作成日時
    #   * nextPageToken => 次ページトークン
    def describe_subscribe(request, pageToken = nil, limit = nil)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('notificationName'); raise ArgumentError.new(); end
      if not request['notificationName']; raise ArgumentError.new(); end
      query = {}
      if pageToken; query['pageToken'] = pageToken; end
      if limit; query['limit'] = limit; end
      return get(
          'Gs2Notification',
          'DescribeSubscribe',
          @@ENDPOINT,
          '/notification/' + request['notificationName'] + '/subscribe',
          query);
    end
    
    # 通知先を作成<br>
    # <br>
    # E-Mail, HTTP/HTTPS 通信を指定して通知先を登録できます。<br>
    # 通知先は1つの通知に対して複数登録することもできます。<br>
    # <br>
    # そのため、メールとSlackに通知する。といった利用ができます。<br>
    # <br>
    # type に指定できるパラメータ<br>
    #
    # * email
    # * http/https
    #
    # <br>
    # endpoint には type に指定したプロトコルによって指定する内容が変わります。<br>
    # email を選択した場合には メールアドレスを、<br>
    # http/https を選択した場合には URL を指定してください。<br>
    # <br>
    # http/https を選択した場合には登録時に疎通確認を行います。<br>
    # 指定したURLでPOSTリクエストを受け付けられる状態で登録してください。<br>
    # 疎通確認の通信は通常の通知とは異なり、body パラメータがからの通信が発生します。ご注意ください。<br>
    #
    # @param request [Array]
    #   * notificationName => 通知名
    #   * name => 通知先名
    #   * type => 通知プロトコル
    #   * endpoint => 通知先
    # @return [Array]
    #   * item
    #     * subscribeId => 通知先ID
    #     * notificationId => 通知ID
    #     * type => 通知プロトコル
    #     * endpoint => 通知先
    #     * createAt => 作成日時
    def create_subscribe(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('notificationName'); raise ArgumentError.new(); end
      if not request['notificationName']; raise ArgumentError.new(); end
      body = {}
      if request.has_key?('name'); body['name'] = request['name']; end
      if request.has_key?('type'); body['type'] = request['type']; end
      if request.has_key?('endpoint'); body['endpoint'] = request['endpoint']; end
      query = {}
      return post(
          'Gs2Notification',
          'CreateSubscribe',
          @@ENDPOINT,
          '/notification/' + request['notificationName'] + '/subscribe',
          body,
          query);
    end
    
    # 通知先を取得
    #
    # @param request [Array]
    #   * notificationName => 通知名
    #   * subscribeId => 通知先ID
    # @return [Array]
    #   * item
    #     * subscribeId => 通知先ID
    #     * notificationId => 通知ID
    #     * type => 通知プロトコル
    #     * endpoint => 通知先
    #     * createAt => 作成日時
    def get_subscribe(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('notificationName'); raise ArgumentError.new(); end
      if not request['notificationName']; raise ArgumentError.new(); end
      if not request.has_key?('subscribeId'); raise ArgumentError.new(); end
      if not request['subscribeId']; raise ArgumentError.new(); end
      query = {}
      return get(
          'Gs2Notification',
          'GetSubscribe',
          @@ENDPOINT,
          '/notification/' + request['notificationName'] + '/subscribe/' + request['subscribeId'],
          query);
    end
    
    # 通知先を削除
    # 
    # @param request [Array]
    #   * notificationName => 通知名
    #   * subscribeId => 通知先ID
    def delete_subscribe(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('notificationName'); raise ArgumentError.new(); end
      if not request['notificationName']; raise ArgumentError.new(); end
      if not request.has_key?('subscribeId'); raise ArgumentError.new(); end
      if not request['subscribeId']; raise ArgumentError.new(); end
      query = {}
      return delete(
          'Gs2Notification',
          'DeleteSubscribe',
          @@ENDPOINT,
          '/notification/' + request['notificationName'] + '/subscribe/' + request['subscribeId'],
          query);
    end
  end
end end