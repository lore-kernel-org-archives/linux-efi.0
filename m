Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663E1C3
	for <linux-efi@vger.kernel.org>; Mon,  4 Dec 2023 22:04:29 -0800 (PST)
X-QQ-mid: bizesmtp80t1701756242t12b57rd
Received: from localhost.localdomain ( [222.92.8.138])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 05 Dec 2023 14:04:01 +0800 (CST)
X-QQ-SSF: 01400000000000F0W000000A0000000
X-QQ-FEAT: yFWqZ/siFTGY461mtQHAVX9qS+3hMd0VDE+XGL3skJWo/WyJTDfESqbE1beE2
	rT42drzAkeyUOE1FWbg1cHjNCy0YOahjmLBKa9Sp2N+oUR1MGQOhGLLr43qNyFybMWacpDz
	UeZQKbEs3plTzA1zHsY9gPEP2kj/L134/XUHWIsiH9Sy4jOvp+g5KcV0ur6JnkS1B8qNMRd
	sBM/LPR9QqKi+CHOWkQS/KKP84IBXlMj+PD/1esJLLXli3c6ZmR+0aB0zTqcy0gsZkKAW9w
	VhdtcxNC3AJgiNyAXI+vgFLNndvZ2AAtfFQmEKgXfAsgNZxn+UGJljbs970C++22BrYEsm6
	jgc89hVOye2WEzX9AXZC1h/snDp/2oOMPd4l+TFqh1jIRUmCBv0CZa7AthoWWZfH5HHMln2
	j3IS5fGxCFg=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 8188823437681347932
From: wangyao@lemote.com
To: ardb@kernel.org,
	chenhuacai@kernel.org,
	wangrui@loongson.cn
Cc: linux-efi@vger.kernel.org,
	ainux.wang@gmail.com,
	Wang Yao <wangyao@lemote.com>
Subject: [PATCH v3 0/2] Use load address to calculate kernel entry
Date: Tue,  5 Dec 2023 14:03:43 +0800
Message-Id: <20231205060345.7742-1-wangyao@lemote.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:lemote.com:qybglogicsvrgz:qybglogicsvrgz5a-2

From: Wang Yao <wangyao@lemote.com>

1, The PIE kernel will be loaded anywhere, so use load address to
calculate kernel entry address.

2, Use twice efi_relocate_kernel() to make load address is not equal to
link address for test.

Wang Yao (2):
  efi/loongarch: Use load address to calculate kernel entry address
  efi/loongarch: load address is not equal to link address

 arch/loongarch/include/asm/efi.h              |  2 +-
 drivers/firmware/efi/libstub/loongarch-stub.c | 16 +++++++++++++---
 drivers/firmware/efi/libstub/loongarch.c      |  6 +++---
 3 files changed, 17 insertions(+), 7 deletions(-)

-- 
2.27.0

