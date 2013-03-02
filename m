From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: EFI runtime and kexec
Date: Fri, 01 Mar 2013 18:04:11 -0800
Message-ID: <94a3c086-b0b2-4820-8f4c-66d1496b89dc@email.android.com>
References: <20130301213903.GI30938@pd.tnic> <51312C8F.8000503@zytor.com> <20130301225303.GK30938@pd.tnic> <513132B0.3050308@zytor.com> <20130301230733.GL30938@pd.tnic> <1362180625.29011.4.camel@shinybook.infradead.org> <513151C2.60907@zytor.com> <1362189072.32131.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362189072.32131.6.camel-Fexsq3y4057IgHVZqg5X0TlWvGAXklZc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Yes, but way before... not a problem.  It isn't a thread in the scheduler sense.

David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

>On Fri, 2013-03-01 at 17:11 -0800, H. Peter Anvin wrote:
>> On 03/01/2013 03:30 PM, David Woodhouse wrote:
>> > On Sat, 2013-03-02 at 00:07 +0100, Borislav Petkov wrote:
>> >> Hmm, yeah, that's nasty. This also means option #2 can go too
>because
>> >> of the fixed addresses. Option #1 is also kinda polluting user
>address
>> >> space 
>> > 
>> > User address space is there to be polluted. Create a "kernel
>thread" for
>> > invoking EFI, except that this kernel thread actually has userspace
>page
>> > tables. Set up those page tables however the hell you like, and
>then
>> > just make sure you always invoke EFI runtime services from that
>thread.
>> > 
>> 
>> Just FYI: as far as I know we already have such a "thread".
>
>In that case it seems like this option is fairly much a no-brainer.
>
>Do we make any calls to runtime services during early boot (before we'd
>have such a thread set up for use)?

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
