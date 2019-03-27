From: Mimi Zohar <zohar@linux.ibm.com>
Subject: Re: [PATCH 1/2] efi: add a function for transferring status to
 string
Date: Wed, 27 Mar 2019 15:04:02 -0400
Message-ID: <1553713442.4608.20.camel@linux.ibm.com>
References: <20190324002621.3551-1-jlee@suse.com>
         <CAKv+Gu9B6h3zGVTctepd1GE5LaaMaT5x14Le1v05AOhbH36bpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9B6h3zGVTctepd1GE5LaaMaT5x14Le1v05AOhbH36bpQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@fedoraproject.org>, Nayna Jain <nayna@linux.ibm.com>, linux-efi <linux-efi@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, Kees Cook <keescook@chromium.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-Id: linux-efi@vger.kernel.org

On Wed, 2019-03-27 at 19:58 +0100, Ard Biesheuvel wrote:
> On Sun, 24 Mar 2019 at 01:26, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
> >
> > This function can be used to transfer EFI status code to string
> > for printing out debug message. Using this function can improve
> > the readability of log.

Maybe instead of "for transferring status" use "to convert the status
value to a" in the Subject line and here in the patch description.

> >
> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Anton Vorontsov <anton@enomsg.org>
> > Cc: Colin Cross <ccross@android.com>
> > Cc: Tony Luck <tony.luck@intel.com>
> > Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
> > ---
> >  include/linux/efi.h | 28 ++++++++++++++++++++++++++++
> >  1 file changed, 28 insertions(+)
> >
> > diff --git a/include/linux/efi.h b/include/linux/efi.h
> > index 54357a258b35..a43cb0dc37af 100644
> > --- a/include/linux/efi.h
> > +++ b/include/linux/efi.h
> > @@ -1768,4 +1768,32 @@ struct linux_efi_memreserve {
> >  #define EFI_MEMRESERVE_COUNT(size) (((size) - sizeof(struct linux_efi_memreserve)) \
> >         / sizeof(((struct linux_efi_memreserve *)0)->entry[0]))
> >
> > +#define EFI_STATUS_STR(_status) \
> > +case EFI_##_status: \
> > +       return "EFI_" __stringify(_status);
> > +
> > +static inline char *
> > +efi_status_to_str(efi_status_t status)
> > +{
> > +       switch (status) {
> > +       EFI_STATUS_STR(SUCCESS)
> > +       EFI_STATUS_STR(LOAD_ERROR)
> > +       EFI_STATUS_STR(INVALID_PARAMETER)
> > +       EFI_STATUS_STR(UNSUPPORTED)
> > +       EFI_STATUS_STR(BAD_BUFFER_SIZE)
> > +       EFI_STATUS_STR(BUFFER_TOO_SMALL)
> > +       EFI_STATUS_STR(NOT_READY)
> > +       EFI_STATUS_STR(DEVICE_ERROR)
> > +       EFI_STATUS_STR(WRITE_PROTECTED)
> > +       EFI_STATUS_STR(OUT_OF_RESOURCES)
> > +       EFI_STATUS_STR(NOT_FOUND)
> > +       EFI_STATUS_STR(ABORTED)
> > +       EFI_STATUS_STR(SECURITY_VIOLATION)
> > +       default:
> > +               pr_warn("Unknown efi status: 0x%lx", status);
> > +       }
> > +
> > +       return "Unknown efi status";
> > +}
> > +
> >  #endif /* _LINUX_EFI_H */
> > --
> > 2.16.4
> >
> 
> Please turn this into a proper function so that not every calling
> object has to duplicate all these strings.

Hi Ard,

Keeping the status values and strings in sync is difficult.  I was
going to suggest moving the macro immediately after the status value
definitions.

Mimi 
