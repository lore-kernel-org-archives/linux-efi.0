From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: EFI runtime and kexec
Date: Fri, 01 Mar 2013 15:50:03 -0800
Message-ID: <51313EAB.7010707@zytor.com>
References: <20130301213903.GI30938@pd.tnic> <51312C8F.8000503@zytor.com> <20130301225303.GK30938@pd.tnic> <513132B0.3050308@zytor.com> <20130301230733.GL30938@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130301230733.GL30938-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/01/2013 03:07 PM, Borislav Petkov wrote:
> 
> Hmm, yeah, that's nasty. This also means option #2 can go too because
> of the fixed addresses. Option #1 is also kinda polluting user address
> space so maybe the most elegant one would be #4, AFAICT.
> 

No, it doesn't pollute the user address space, because the EFI BIOS is
effectively a process.  We *have* to switch cr3 anyway around EFI calls,
because BIOSes in the field are known to use physical addresses instead
of virtual.

If Windows really does map EFI BIOS 1:1 then that explains why, and is
probably going to be the stable thing going forward.

	-hpa
