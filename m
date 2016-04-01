From: Octavian Purdila <octavian.purdila@intel.com>
Subject: Re: [RFC PATCH 02/10] acpi: install SSDT tables from initrd
Date: Fri, 1 Apr 2016 13:11:55 +0300
Message-ID: <CAE1zotJ1fa4m-_FO3PUQK8_p0vHcfWD5TmuMdxOSHDjku421pA@mail.gmail.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
	<1459417026-6697-3-git-send-email-octavian.purdila@intel.com>
	<1AE640813FDE7649BE1B193DEA596E883BB66258@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E883BB66258@SHSMSX101.ccr.corp.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>, "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Tirdea, Irina" <irina.tirdea@intel.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 1, 2016 at 8:05 AM, Zheng, Lv <lv.zheng@intel.com> wrote:
> Hi,
>
> IMO, there is already a similar function upstreamed:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=c85cc81
> Could it work for your use case?

Yes, it is basically the same.

The only difference is on how we handle taint. I think we should use a
new taint for overlays and that we don't need to disable lockdep.

BTW, why is lockdep disabled when we override?
