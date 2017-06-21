From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v3 2/2] eif/capsule-pstore: Add capsule pstore backend
Date: Wed, 21 Jun 2017 13:02:11 -0700
Message-ID: <CAGXu5jLnnuVBOdsEjNMb35oJb=nVNnU3Dc0XxpVp5gq5nUht1w@mail.gmail.com>
References: <20170619175445.90281-1-qiuxu.zhuo@intel.com> <CAGXu5jKMuiT6CL4L=tUfL_8EgDOMy67UnU5_-rn68BFAEYdg9w@mail.gmail.com>
 <E6AF1AFDEA62A94A97508F458CBDD47F6F5A51E6@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E6AF1AFDEA62A94A97508F458CBDD47F6F5A51E6-0J0gbvR4kThpB2pF5aRoyrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Zhuo, Qiuxu" <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 21, 2017 at 1:45 AM, Zhuo, Qiuxu <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> From: keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org [mailto:keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org] On Behalf Of Kees Cook
>> Sent: Wednesday, June 21, 2017 7:27 AM
>>
>> > +
>> > +static bool efi_capsule_pstore_disable =
>> > +       IS_ENABLED(CONFIG_CAPSULE_PSTORE_DEFAULT_DISABLE);
>>
>> This can be marked __ro_after_init.
>
>    OK. Will mark it __ro_after_init in next version.
>
>> > +
>> > +               rec->type = record->type;
>> > +               rec->timestamp = get_seconds();
>>
>> timestamp will already be correctly populated by the pstore API, so it should be copied from there rather than using get_seconds() which may not be functional during resume, etc.
>
> Looks like that the timestamp member "time" of struct pstore_record passed from pstore "fs/pstore/platform.c" -> pstore_dump() is not set for DMESG case.

The change for the timestamp has been in the -next tree ("pstore:
Populate pstore record->time field"). If that doesn't work how you
want it, please let me know and I can adjust it.

-Kees

-- 
Kees Cook
Pixel Security
