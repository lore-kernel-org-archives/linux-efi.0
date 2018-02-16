From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] efivars: reading variables can generate SMIs
Date: Fri, 16 Feb 2018 11:18:12 +0000
Message-ID: <CAKv+Gu_SD6yWJMGbTwGUWXtrgZKPkpANNaGe1PUruTG9j0yhcg@mail.gmail.com>
References: <20180215182208.35003-1-joe.konno@linux.intel.com>
 <CAKv+Gu80pJ5tbGoJqBm8CCKrEZXdkE83c944383KbQ5jREUC0Q@mail.gmail.com>
 <20180216105548.GA29042@pd.tnic> <CAKv+Gu8qm2wFxY56-eRLkLZB6fRUCmZbZo=4cvo5e4JDFh01Gg@mail.gmail.com>
 <20180216110821.GB29042@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180216110821.GB29042-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Joe Konno <joe.konno-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 16 February 2018 at 11:08, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
> On Fri, Feb 16, 2018 at 10:58:47AM +0000, Ard Biesheuvel wrote:
>> By your own reasoning above, that's a no-no as well.
>
> I'm sure we can come up with some emulation - the same way we did the
> BIOS emulation.
>
>> But thanks for your input. Anyone else got something constructive to contribute?
>
> The not-breaking userspace is constructive contribution. The last
> paragraph is my usual rant.
>

Fair enough. And I am not disagreeing with you either.

So question to Joe: is it well defined which variables may exhibit
this behavior? Given that UEFI variables are GUID scoped, would
whitelisting certain GUIDs (the ones userland currently relies on to
be readable my non-privileged users) and making everything else
user-only solve this problem as well?
