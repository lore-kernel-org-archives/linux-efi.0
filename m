From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [efi:urgent 1/1] drivers/firmware/efi/libstub/fdt.c:303:9: warning:
 cast from pointer to integer of different size
Date: Tue, 20 Dec 2016 13:35:01 +0000
Message-ID: <58593385.4000808@arm.com>
References: <201612200741.F41hYqms%fengguang.wu@intel.com> <20161220113956.GB2225@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161220113956.GB2225-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Matt,

On 20/12/16 11:39, Matt Fleming wrote:
> James, could you take care of fixing this up? You need to cast
> memory_map to unsigned long before u64 on ARM.

Yes, sure - sorry I didn't spot this. It turns out my ARM config didn't build
the EFI stub. Oops.

Fixup patch incoming,


Thanks,

James
