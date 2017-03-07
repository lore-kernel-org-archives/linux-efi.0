From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 06/18] pstore: Extract common arguments into structure
Date: Wed, 8 Mar 2017 01:22:01 +0900
Message-ID: <CADWwUUZ3+ZwZaijPxAtacegjtp_0uPVpKZyH8jE045+n1Bp-zQ@mail.gmail.com>
References: <1488837332-71582-1-git-send-email-keescook@chromium.org> <1488837332-71582-7-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1488837332-71582-7-git-send-email-keescook@chromium.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Nobuhiro Iwamatsu <nobuhiro.iwamatsu.kw@hitachi.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Nathan Fontenot <nfont@linux.vnet.ibm.com>, Pan Xinhui <xinhui.pan@linux.vnet.ibm.com>, Daniel Axtens <dja@axtens.net>, Paul Gortmaker <paul.gortmaker@windriver.com>, Geliang Tang <geliangtang@163.com>, linuxppc-dev@lists.ozlabs.org, linux-acp
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 7, 2017 at 6:55 AM, Kees Cook <keescook@chromium.org> wrote:
> The read/mkfile pair pass the same arguments and should be cleared
> between calls. Move to a structure and wipe it after every loop.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  fs/pstore/platform.c   | 55 +++++++++++++++++++++++++++-----------------------
>  include/linux/pstore.h | 28 ++++++++++++++++++++++++-
>  2 files changed, 57 insertions(+), 26 deletions(-)
>
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index 320a673ecb5b..3fa1575a6e36 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -766,16 +766,9 @@ EXPORT_SYMBOL_GPL(pstore_unregister);
>  void pstore_get_records(int quiet)
>  {
>         struct pstore_info *psi = psinfo;
> -       char                    *buf = NULL;
> -       ssize_t                 size;
> -       u64                     id;
> -       int                     count;
> -       enum pstore_type_id     type;
> -       struct timespec         time;
> +       struct pstore_record    record = { .psi = psi, };
>         int                     failed = 0, rc;
> -       bool                    compressed;
>         int                     unzipped_len = -1;
> -       ssize_t                 ecc_notice_size = 0;
>
>         if (!psi)
>                 return;
> @@ -784,39 +777,51 @@ void pstore_get_records(int quiet)
>         if (psi->open && psi->open(psi))
>                 goto out;
>
> -       while ((size = psi->read(&id, &type, &count, &time, &buf, &compressed,
> -                                &ecc_notice_size, psi)) > 0) {
> -               if (compressed && (type == PSTORE_TYPE_DMESG)) {
> +       while ((record.size = psi->read(&record.id, &record.type,
> +                                &record.count, &record.time,
> +                                &record.buf, &record.compressed,
> +                                &record.ecc_notice_size,
> +                                record.psi)) > 0) {
> +               if (record.compressed &&
> +                   record.type == PSTORE_TYPE_DMESG) {
>                         if (big_oops_buf)
> -                               unzipped_len = pstore_decompress(buf,
> -                                                       big_oops_buf, size,
> +                               unzipped_len = pstore_decompress(
> +                                                       record.buf,
> +                                                       big_oops_buf,
> +                                                       record.size,
>                                                         big_oops_buf_sz);
>
>                         if (unzipped_len > 0) {
> -                               if (ecc_notice_size)
> +                               if (record.ecc_notice_size)
>                                         memcpy(big_oops_buf + unzipped_len,
> -                                              buf + size, ecc_notice_size);
> -                               kfree(buf);
> -                               buf = big_oops_buf;
> -                               size = unzipped_len;
> -                               compressed = false;
> +                                              record.buf + recorrecord.size,

A typo on record.size.

Thanks,
Namhyung
