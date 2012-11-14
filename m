From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86/EFI: check table header length in efi_bgrt_init()
Date: Wed, 14 Nov 2012 09:55:08 +0000
Message-ID: <1352886908.15747.126.camel@mfleming-mobl1.ger.corp.intel.com>
References: <509A9E6002000078000A7079@nat28.tlf.novell.com>
	 <1352837295.15747.72.camel@mfleming-mobl1.ger.corp.intel.com>
	 <50A36E1202000078000A8679@nat28.tlf.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50A36E1202000078000A8679-ce6RLXgGx+vWGUEhTRrCg1aTQe2KTcn/@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: mingo-X9Un+BFzKDI@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 2012-11-14 at 09:10 +0000, Jan Beulich wrote:
> No, I haven't. I just spotted that omission in the context of the
> apparent lack of checking of the valid flag (which meanwhile was
> explained to me as being intentional).

OK, thanks for the clarification Jan.

I don't have anything else queued up for the next merge window, so I
will probably submit this next week after -rc6 as I'm awaiting feedback
for another bug fix and that will allow me to batch the two together.

Alternatively, tip folks, feel free to take this directly.

-- 
Matt Fleming, Intel Open Source Technology Center
