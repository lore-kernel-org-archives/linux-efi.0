From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] pstore: return error code (if any) from efi_pstore_write
Date: Fri, 17 Mar 2017 22:52:28 +0000
Message-ID: <CAKv+Gu848NfAFSy2me9BjeQqSjFazROcVVAWwafa0Us_RwqOPw@mail.gmail.com>
References: <1489416765.32205.14.camel@evgeny-pc.tm.intel.com>
 <CAKv+Gu92Lq62aJF4Ki2DU577xs09JWPLaOfRENRo=+VSyEBhVQ@mail.gmail.com> <1489493144.11640.29.camel@evgeny-pc.tm.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489493144.11640.29.camel-HiM4UUiQNY10sU3rIFUpn1DQ4js95KgL@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalugin, Evgeny" <evgeny.kalugin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org" <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org" <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 14 March 2017 at 09:59, Kalugin, Evgeny <evgeny.kalugin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, 2017-03-14 at 08:24 +0000, Ard Biesheuvel wrote:
>> On 13 March 2017 at 12:46, Kalugin, Evgeny <evgeny.kalugin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> > From 655a261d71af9de62e0e23ae0eb6f75037ae5e3e Mon Sep 17 00:00:00 2001
>> > From: Evgeny Kalugin <evgeny.kalugin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> > Date: Tue, 7 Mar 2017 14:22:25 +0000
>> > Subject: [PATCH] pstore: return error code (if any) from efi_pstore_write
>> >
>> > For some reason return value from actual variable setting was ignored.
>> > With this change error code get transferred upwards through call stack.
>> >
>> > Signed-off-by: Evgeny Kalugin <evgeny.kalugin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> Thanks for the patch.
>>
>> Could you give a bit more detail on how this broke things for you?
>
> Well, it haven't broken much things for me yet. I just found it when
> tried to debug one problem in efi-pstore. There I was about to watch
> return value from write call, when noticed that it is always zero and
> that has not so much sense obviously.
>

Queued for v4.12, thanks
