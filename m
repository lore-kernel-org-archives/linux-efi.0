From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: EFI runtime and kexec
Date: Fri, 01 Mar 2013 17:11:30 -0800
Message-ID: <513151C2.60907@zytor.com>
References: <20130301213903.GI30938@pd.tnic> <51312C8F.8000503@zytor.com>  <20130301225303.GK30938@pd.tnic> <513132B0.3050308@zytor.com>  <20130301230733.GL30938@pd.tnic> <1362180625.29011.4.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362180625.29011.4.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/01/2013 03:30 PM, David Woodhouse wrote:
> On Sat, 2013-03-02 at 00:07 +0100, Borislav Petkov wrote:
>> Hmm, yeah, that's nasty. This also means option #2 can go too because
>> of the fixed addresses. Option #1 is also kinda polluting user address
>> space 
> 
> User address space is there to be polluted. Create a "kernel thread" for
> invoking EFI, except that this kernel thread actually has userspace page
> tables. Set up those page tables however the hell you like, and then
> just make sure you always invoke EFI runtime services from that thread.
> 

Just FYI: as far as I know we already have such a "thread".

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
