From: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] efivars: reading variables can generate SMIs
Date: Fri, 16 Feb 2018 19:51:27 +0000
Message-ID: <CACdnJutpJa3nnH0Cs=x-=+GYp+9R5ZJkREhd7DvwDcmyjufSHA@mail.gmail.com>
References: <20180215182208.35003-1-joe.konno@linux.intel.com>
 <CAKv+Gu80pJ5tbGoJqBm8CCKrEZXdkE83c944383KbQ5jREUC0Q@mail.gmail.com>
 <20180216105548.GA29042@pd.tnic> <CAKv+Gu8qm2wFxY56-eRLkLZB6fRUCmZbZo=4cvo5e4JDFh01Gg@mail.gmail.com>
 <20180216110821.GB29042@pd.tnic> <CAKv+Gu_SD6yWJMGbTwGUWXtrgZKPkpANNaGe1PUruTG9j0yhcg@mail.gmail.com>
 <20180216184832.sqreq5zhar3jqdae@jbkonno-saint14> <20180216192220.wljl23g533sc3oxg@redhat.com>
 <CAKv+Gu9=wny1J+-tZCdoGYUSZjfWgbiB9b_MdgpssdcTVXtKkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu9=wny1J+-tZCdoGYUSZjfWgbiB9b_MdgpssdcTVXtKkA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, joe.konno-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 16, 2018 at 11:31 AM Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
wrote:
> This is why I was leaning towards applying these patches: not breaking
> userland is an important rule, but it does not imply every aspect of
> behavior observable by userland is set in stone. In other words, I
> agree with Peter that making this change does not *break* userland in
> a way anyone is likely to care deeply about.

In some modes tpmtotp will run as non-root and expect to be able to read an
EFI variable.
