From: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Subject: Re: [PATCH 12/16] Fix types in EFI calls to match EFI function definitions.
Date: Sat, 31 Aug 2013 00:14:22 +0100
Message-ID: <CACxGe6tJyGDN5nTePuwcV_W44Fk+mku+V8EoOvPaos72mbKdEw@mail.gmail.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
 <1376090777-20090-13-git-send-email-roy.franz@linaro.org> <20130830133902.AEA7A3E102A@localhost>
 <CAFECyb-J4gTiAQkKVT8qt94Tk6-_jVdX=sNM7VkXkyvPdEeZFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFECyb-J4gTiAQkKVT8qt94Tk6-_jVdX=sNM7VkXkyvPdEeZFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave Martin <dave.martin-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Aug 31, 2013 at 12:12 AM, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Fri, Aug 30, 2013 at 6:39 AM, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org> wrote:
>> I think you need some description in the commit text about why the type
>> of chunksize is changing. It's not clear why you're making this change.
>> It is a bug fix?
>
> The type was changed to match the EFI_FILE_PROTOCOL specification -
> chunk size is
> defined as a native width unsigned integer.  So yes, this is a bug in
> that this is wrong for
> ia32, since that really should be a u32 in that case.
> Since the x86 wrappers break type checking by the compiler these types
> were never checked at compile time
> before.  chunksize is the the only change that isn't a cast to a type
> of void pointer.
>
> I can break this change out as a separate patch if desired.

I don't think it needs to be in a separate patch, but it does need to
be described in the patch description.

g.
