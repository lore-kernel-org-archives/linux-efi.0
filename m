From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] x86: boot: Fix EFI stub alignment
Date: Tue, 18 Sep 2018 15:04:54 -0700
Message-ID: <CAKv+Gu8-u+Nfw0hx_iyMFFhG=-T0M_OuKfg34m1U3RgC13dUqA@mail.gmail.com>
References: <20180916152246.GG4765@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180916152246.GG4765@decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 16 September 2018 at 08:22, Ben Hutchings <ben@decadent.org.uk> wrote:
> We currently align the end of the compressed image to a multiple of
> 16.  However the PE-COFF header included in the EFI stub says that the
> file alignment is 32 bytes, and when adding an EFI signature to the
> file it must first be padded to this alignment.
>
> sbsigntool commands warn about this:
>
>     warning: file-aligned section .text extends beyond end of file
>     warning: checksum areas are greater than image size. Invalid section =
table?
>
> Worse, pesign-at least when creating a detached signature=E2=80=94uses th=
e
> hash of the unpadded file, resulting in an invalid signature if
> padding is required.
>
> Avoid both these problems by increasing alignment to 32 bytes when
> CONFIG_EFI_STUB is enabled.
>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---

Thanks, queued in efi/next.


> --- a/arch/x86/boot/tools/build.c
> +++ b/arch/x86/boot/tools/build.c
> @@ -391,6 +391,13 @@ int main(int argc, char ** argv)
>                 die("Unable to mmap '%s': %m", argv[2]);
>         /* Number of 16-byte paragraphs, including space for a 4-byte CRC=
 */
>         sys_size =3D (sz + 15 + 4) / 16;
> +#ifdef CONFIG_EFI_STUB
> +       /*
> +        * COFF requires minimum 32-byte alignment of sections, and
> +        * adding a signature is problematic without that alignment.
> +        */
> +       sys_size =3D (sys_size + 1) & ~1;
> +#endif
>
>         /* Patch the setup code with the appropriate size parameters */
>         buf[0x1f1] =3D setup_sectors-1;
