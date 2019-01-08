From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: use 32-bit alignment for efi_guid_t
Date: Tue, 8 Jan 2019 17:22:24 +0100
Message-ID: <CAKv+Gu9rAo3rFg+CC_vojbaSqguZQoCH1wZ3K91od6O9v7CCEQ@mail.gmail.com>
References: <20190108152829.11579-1-ard.biesheuvel@linaro.org>
 <20190108155321.7us32cbh6jgvwaw5@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190108155321.7us32cbh6jgvwaw5@bivouac.eciton.net>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>, linux-efi <linux-efi@vger.kernel.org>, Laszlo Ersek <lersek@redhat.com>, Ingo Molnar <mingo@kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 8 Jan 2019 at 16:53, Leif Lindholm <leif.lindholm@linaro.org> wrote:
>
> On Tue, Jan 08, 2019 at 04:28:29PM +0100, Ard Biesheuvel wrote:
> > The UEFI spec and EDK2 reference implementation both define EFI_GUID as
> > struct { u32 a; u16; b; u16 c; u8 d[8]; }; and so the implied alignment
> > is 32 bits not 8 bits like our guid_t. In some cases (i.e., on 32-bit ARM),
> > this means that firmware services invoked by the kernel may assume that
> > efi_guid_t* arguments are 32-bit aligned, and use memory accessors that
> > do not tolerate misalignment. So let's set the minimum alignment to 32 bits.
> >
> > Note that the UEFI spec as well as some comments in the EDK2 code base
> > suggest that EFI_GUID should be 64-bit aligned, but this appears to be
> > a mistake, given that no code seems to exist that actually enforces that
> > or relies on it.
>
> Whereas code does exist that relies on it being 32-bit aligned...
>

Well, not entirely. Code exists that expects that the size of a struct
incorporating a efi_guid_t is not rounded up to 8 bytes.

In particular, there is

typedef struct {
    efi_guid_t guid;
    unsigned long table;
} efi_config_table_t;

and its EDK2 counterpart

typedef struct {
  ///
  /// The 128-bit GUID value that uniquely identifies the system
configuration table.
  ///
  EFI_GUID                          VendorGuid;
  ///
  /// A pointer to the table associated with VendorGuid.
  ///
  VOID                              *VendorTable;
} EFI_CONFIGURATION_TABLE;

neither of which are defined as packed structs, and which are used to
describe entries in the configuration table array referenced in the
UEFI system table, and so size matters. On 32-bit architectures, this
struct would change size if we increase the alignment of the
VendorGuid member, unless we turn it into a packed struct.

In any case, it seems entirely pointless to update the reference
implementation to enforce 64 bit alignment for EFI_GUID in general,
only to create a lots of issues like the above that will need to be
hunted down and fixed. So for all intents and purposes, this 64-bit
alignment of EFI_GUID in the UEFI spec can be ignored.

> > Reported-by: Heinrich Schuchardt <xypron.glpk@gmx.de>,
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> Reviewed-by: Leif Lindholm <leif.lindholm@linaro.org>
>

Thanks.

> > ---
> >  include/linux/efi.h | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/efi.h b/include/linux/efi.h
> > index 45ff763fba76..be08518c2553 100644
> > --- a/include/linux/efi.h
> > +++ b/include/linux/efi.h
> > @@ -48,7 +48,20 @@ typedef u16 efi_char16_t;          /* UNICODE character */
> >  typedef u64 efi_physical_addr_t;
> >  typedef void *efi_handle_t;
> >
> > -typedef guid_t efi_guid_t;
> > +/*
> > + * The UEFI spec and EDK2 reference implementation both define EFI_GUID as
> > + * struct { u32 a; u16; b; u16 c; u8 d[8]; }; and so the implied alignment
> > + * is 32 bits not 8 bits like our guid_t. In some cases (i.e., on 32-bit ARM),
> > + * this means that firmware services invoked by the kernel may assume that
> > + * efi_guid_t* arguments are 32-bit aligned, and use memory accessors that
> > + * do not tolerate misalignment. So let's set the minimum alignment to 32 bits.
> > + *
> > + * Note that the UEFI spec as well as some comments in the EDK2 code base
> > + * suggest that EFI_GUID should be 64-bit aligned, but this appears to be
> > + * a mistake, given that no code seems to exist that actually enforces that
> > + * or relies on it.
> > + */
> > +typedef guid_t efi_guid_t __aligned(__alignof__(u32));
> >
> >  #define EFI_GUID(a,b,c,d0,d1,d2,d3,d4,d5,d6,d7) \
> >       GUID_INIT(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)
> > --
> > 2.20.1
> >
