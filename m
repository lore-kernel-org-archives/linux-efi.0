From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH] efi: Free existing memory map before installing new
 memory map
Date: Tue, 26 Jun 2018 07:18:28 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F45FD1614@ORSMSX111.amr.corp.intel.com>
References: <1529980892-11833-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <201806261053.B3CmI5Dm%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201806261053.B3CmI5Dm%fengguang.wu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: lkp <lkp@intel.com>
Cc: "kbuild-all@01.org" <kbuild-all@01.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Dave Young <dyoung@redhat.com>, Laszlo Ersek <lersek@redhat.com>, Bhupesh Sharma <bhsharma@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

> 
> Hi Sai,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on linus/master]
> [also build test ERROR on v4.18-rc2 next-20180625] [if your patch is applied to
> the wrong git tree, please drop us a note to help improve the system]

Since efi_memmap_free() is a recently introduced API [1], please note that the patch 
is based on efi tree @https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git

[1] https://lkml.org/lkml/2018/6/22/39

Regards,
Sai
