From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: kexec crash on OVMF i386 + x86_64 kernel (Re: [PATCH v4]
 x86/boot: Use efi_setup_data for searching RSDP on kexec-ed kernel)
Date: Wed, 17 Apr 2019 17:57:20 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F48AFF5CF@ORSMSX114.amr.corp.intel.com>
References: <20190412025416.GA11070@jeru.linux.bs1.fc.nec.co.jp>
 <20190412084956.GC19808@zn.tnic> <20190412133528.GD19808@zn.tnic>
 <cc2c1dbe-4fb3-fb7d-0540-c04734fc15cb@ce.jp.nec.com>
 <20190415090717.GA29317@zn.tnic> <20190415102525.GB29317@zn.tnic>
 <23309b73-d135-a207-564b-6003cee39184@ce.jp.nec.com>
 <4dbbbb4b-7af9-bd98-b567-890407a15cd1@ce.jp.nec.com>
 <20190416094554.GF27892@zn.tnic>
 <befd6560-f41a-b142-a839-aaab861dee5a@ce.jp.nec.com>
 <20190417051418.GC8411@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190417051418.GC8411@dhcp-128-65.nay.redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Borislav Petkov <bp@alien8.de>, Chao Fan <fanc.fnst@cn.fujitsu.com>, Baoquan He <bhe@redhat.com>, Kairui Song <kasong@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "kexec@lists.infradead.org" <kexec@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

> Added efi people.
> 
> I remember previously Sai did some efi32 tests for kexec, but I'm not sure if he
> tested EFI32 + 64bit kernel.
> 
> Kexec status is not certain because I'm not sure anyone tesed and reported
> issues for that.

No.. I didn't test kexec on EFI32 + 64bit kernel and I also haven't tested kexec'ing from 
kexec'd kernel.

Regards,
Sai
