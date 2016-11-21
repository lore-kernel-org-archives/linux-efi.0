From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 9/9] MODSIGN: Allow the "db" UEFI variable to be suppressed
Date: Mon, 21 Nov 2016 16:42:45 +0000
Message-ID: <CAKv+Gu__wAnOawWZWVF6NF3En0suuFTBrFwwZ5KosqBU8LVHMA@mail.gmail.com>
References: <147931984418.16460.6639993676886095760.stgit@warthog.procyon.org.uk>
 <147931990959.16460.3038875071067540418.stgit@warthog.procyon.org.uk>
 <CAKv+Gu96ihE7pHrCCeCpy78man-r821b3Vs4Tn_RsYyzY4HV2Q@mail.gmail.com> <CA+5PVA7SivAegwxdxuiAFL41Apie4JLK5KbtGGHLr1fP0p3MsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+5PVA7SivAegwxdxuiAFL41Apie4JLK5KbtGGHLr1fP0p3MsQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 21 November 2016 at 16:26, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org> wrote:
> On Mon, Nov 21, 2016 at 11:18 AM, Ard Biesheuvel
> <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> On 16 November 2016 at 18:11, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
>>>
>>> If a user tells shim to not use the certs/hashes in the UEFI db variable
>>> for verification purposes, shim will set a UEFI variable called
>>> MokIgnoreDB.  Have the uefi import code look for this and ignore the db
>>> variable if it is found.
>>>
>>
>> Similar concern as in the previous patch: it appears to me that you
>> can DoS a machine by setting MokIgnoreDB if, e.g., its modules are
>> signed against a cert that resides in db, and shim/mokmanager are not
>> being used.
>
> If shim/mokmanager aren't used, then you can't actually modify
> MokIgnoreDB.  Again, it requires physical access and a reboot into
> mokmanager to actually take effect.
>

This does the trick as well

printf "\x07\x00\x00\x00\x01" >
/sys/firmware/efi/efivars/MokIgnoreDB-605dab50-e046-4300-abb6-3dd810dd8b23
