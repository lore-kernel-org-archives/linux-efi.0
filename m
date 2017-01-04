From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 10/10] uuid: Constify UUID compound literals
Date: Wed, 4 Jan 2017 17:54:08 +0000
Message-ID: <CAKv+Gu8GqCrjOM6nTTHQckyUzrv+BO-B=st35yOptPfjA7Hitg@mail.gmail.com>
References: <cover.1483318593.git.lukas@wunner.de> <c61bbe4733f78c830f6073e86f32159751bbda8c.1483318593.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c61bbe4733f78c830f6073e86f32159751bbda8c.1483318593.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Lukas,

On 2 January 2017 at 10:24, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> The UUID_BE() and UUID_LE() macros (as well as the derived EFI_GUID())
> generate a compound literal for a 128-bit ID.  By default, these are not
> stored in the rodata section but generated on the stack at runtime in a
> very time- and space-inefficient manner.
>

This is not true if you declare those variables static const (in
function scope).

In general, I think we should avoid touching uapi headers for this, so
I would like to explore if we can reach the same result without this
patch. Another objection I have to this patch is that it is context
dependent whether the UUID_[LE_BE]() macros in fact generate compound
literals: this is true for an assignment to a pointer variable, but
when they are used in initializers this is not the case, and so adding
'const' to their definitions is not always appropriate imo.

Are there any instances where simply turning those automatic variables
into static const doesn't work?

> E.g. EFI_FILE_SYSTEM_GUID (964E5B22-6459-11D2-8E39-00A0C969723B) results
> in x86_64 code which requires 80 bytes text instead of 16 bytes rodata:
>
>     c6 44 24 20 22                   movb   $0x22,0x20(%rsp)
>     c6 44 24 21 5b                   movb   $0x5b,0x21(%rsp)
>     c6 44 24 22 4e                   movb   $0x4e,0x22(%rsp)
>     c6 44 24 23 96                   movb   $0x96,0x23(%rsp)
>     c6 44 24 24 59                   movb   $0x59,0x24(%rsp)
>     c6 44 24 25 64                   movb   $0x64,0x25(%rsp)
>     c6 44 24 26 d2                   movb   $0xd2,0x26(%rsp)
>     c6 44 24 27 11                   movb   $0x11,0x27(%rsp)
>     c6 44 24 28 8e                   movb   $0x8e,0x28(%rsp)
>     c6 44 24 29 39                   movb   $0x39,0x29(%rsp)
>     c6 44 24 2a 00                   movb   $0x0,0x2a(%rsp)
>     c6 44 24 2b a0                   movb   $0xa0,0x2b(%rsp)
>     c6 44 24 2c c9                   movb   $0xc9,0x2c(%rsp)
>     c6 44 24 2d 69                   movb   $0x69,0x2d(%rsp)
>     c6 44 24 2e 72                   movb   $0x72,0x2e(%rsp)
>     c6 44 24 2f 3b                   movb   $0x3b,0x2f(%rsp)
>
> gcc 7 improves on this by using 2x movabs + 2x mov instructions,
> amounting to 30 bytes text instead of 16 bytes rodata.  That's more
> space-efficient than 80 bytes but still undesirable from a performance
> and security perspective:
>
>     48 b8 22 5b 4e 96 59 64 d2 11    movabs $0x11d26459964e5b,%rax
>     48 89 44 24 20                   mov    %rax,0x20(%rsp)
>     48 b8 8e 39 00 a0 c9 69 72 3b    movabs $0x3b7269c9a00039,%rax
>     48 89 44 24 28                   mov    %rax,0x28(%rsp)
>
> The reason for generating compound literals on the stack is that they're
> allowed to be modified.  E.g. a pointer to a UUID might be used to
> change some of its 16 bytes.  In the context of UUIDs this seems silly
> though:  The uuid_be, uuid_le and efi_guid_t data types hide the
> distinct bytes making up the ID, the bytes are not meant to be modified.
> Moreover, the UUIDs are usually pre-defined in a spec such as UEFI and
> there's no reason at all to modify them.
>
> Thus, change the UUID_BE and UUID_LE macros to declare the generated
> compound literal const, allowing the compiler to put it in rodata.
>
> When using the compound literal as an initializer for a variable, that
> variable has to be declared const as well for the UUID to become rodata.
>
> Is that all?  Unfortunately not.  Under certain conditions gcc refuses
> to store compound literals in rodata despite them being declared const.
> Rasmus Villemoes opened a bugzilla entry for this in December 2015:
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=68725
>
> The upshot is that if a UUID is passed by value to a function (either
> directly or as a variable), it is stored in rodata.  This is the case
> for efi_guidcmp().  But if the UUID is passed by reference, it is
> generated on the stack, in spite of it being declared const and the
> function parameter being declared const.  This is the case for the
> various EFI boot and runtime services calls such as GetVariable.
> A workaround is to declare a *static* const variable, assign the UUID to
> it and pass the variable by reference to the function.
>
> This issue also affects efi_char16_t strings which are only declared
> const (and not static const).  They're likewise generated on the stack
> at runtime.
>
> clang 3.9 is not better than gcc:  It does the exact opposite by putting
> UUIDs in rodata if they're passed by reference, and generating them on
> the stack if they're passed by value.
>
> Cc: Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> ---
>  include/uapi/linux/uuid.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
> index 3738e5f..9184f01 100644
> --- a/include/uapi/linux/uuid.h
> +++ b/include/uapi/linux/uuid.h
> @@ -29,14 +29,14 @@
>  } uuid_be;
>
>  #define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)               \
> -((uuid_le)                                                             \
> +((const uuid_le)                                                       \
>  {{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
>     (b) & 0xff, ((b) >> 8) & 0xff,                                      \
>     (c) & 0xff, ((c) >> 8) & 0xff,                                      \
>     (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
>
>  #define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)               \
> -((uuid_be)                                                             \
> +((const uuid_be)                                                       \
>  {{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
>     ((b) >> 8) & 0xff, (b) & 0xff,                                      \
>     ((c) >> 8) & 0xff, (c) & 0xff,                                      \
> --
> 2.11.0
>
