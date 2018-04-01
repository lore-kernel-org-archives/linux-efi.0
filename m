From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 1/2] efi: Export boot-services code and data as
 debugfs-blobs
Date: Sun, 1 Apr 2018 08:12:05 +0800
Message-ID: <201804010732.6JjZvmsF%fengguang.wu@intel.com>
References: <20180331121944.8618-1-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180331121944.8618-1-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: kbuild-all@01.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi Hans,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.16-rc7 next-20180329]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Hans-de-Goede/efi-Export-boot-services-code-and-data-as-debugfs-blobs/20180401-062627
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/firmware/efi/efi.c:324:29: sparse: symbol 'debugfs_blob' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
