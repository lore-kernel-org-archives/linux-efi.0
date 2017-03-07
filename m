From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 06/18] pstore: Extract common arguments into structure
Date: Tue, 7 Mar 2017 11:31:12 -0800
Message-ID: <CAGXu5j+WmpMcZhqkdaVULnRt5wWheE=QeE+Hv7gfS2R2ET8APg@mail.gmail.com>
References: <1488837332-71582-1-git-send-email-keescook@chromium.org>
 <1488837332-71582-7-git-send-email-keescook@chromium.org>
 <CADWwUUZ3+ZwZaijPxAtacegjtp_0uPVpKZyH8jE045+n1Bp-zQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CADWwUUZ3+ZwZaijPxAtacegjtp_0uPVpKZyH8jE045+n1Bp-zQ@mail.gmail.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Pan Xinhui <xinhui.pan@linux.vnet.ibm.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Paul Mackerras <paulus@samba.org>, Anton Vorontsov <anton@enomsg.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Nathan Fontenot <nfont@linux.vnet.ibm.com>, Len Brown <lenb@kernel.org>, Nobuhiro Iwamatsu <nobuhiro.iwamatsu.kw@hitachi.com>, Geliang Tang <geliangtang@163.com>, Tony Luck <tony.luck@intel.com>, Daniel Axtens <dja@axtens.net>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 7, 2017 at 8:22 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> On Tue, Mar 7, 2017 at 6:55 AM, Kees Cook <keescook@chromium.org> wrote:
>> The read/mkfile pair pass the same arguments and should be cleared
>> between calls. Move to a structure and wipe it after every loop.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  fs/pstore/platform.c   | 55 +++++++++++++++++++++++++++-----------------------
>>  include/linux/pstore.h | 28 ++++++++++++++++++++++++-
>>  2 files changed, 57 insertions(+), 26 deletions(-)
>>
>> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
>> index 320a673ecb5b..3fa1575a6e36 100644
>> --- a/fs/pstore/platform.c
>> +++ b/fs/pstore/platform.c
>> @@ -766,16 +766,9 @@ EXPORT_SYMBOL_GPL(pstore_unregister);
>>  void pstore_get_records(int quiet)
>>  {
>>         struct pstore_info *psi = psinfo;
>> -       char                    *buf = NULL;
>> -       ssize_t                 size;
>> -       u64                     id;
>> -       int                     count;
>> -       enum pstore_type_id     type;
>> -       struct timespec         time;
>> +       struct pstore_record    record = { .psi = psi, };
>>         int                     failed = 0, rc;
>> -       bool                    compressed;
>>         int                     unzipped_len = -1;
>> -       ssize_t                 ecc_notice_size = 0;
>>
>>         if (!psi)
>>                 return;
>> @@ -784,39 +777,51 @@ void pstore_get_records(int quiet)
>>         if (psi->open && psi->open(psi))
>>                 goto out;
>>
>> -       while ((size = psi->read(&id, &type, &count, &time, &buf, &compressed,
>> -                                &ecc_notice_size, psi)) > 0) {
>> -               if (compressed && (type == PSTORE_TYPE_DMESG)) {
>> +       while ((record.size = psi->read(&record.id, &record.type,
>> +                                &record.count, &record.time,
>> +                                &record.buf, &record.compressed,
>> +                                &record.ecc_notice_size,
>> +                                record.psi)) > 0) {
>> +               if (record.compressed &&
>> +                   record.type == PSTORE_TYPE_DMESG) {
>>                         if (big_oops_buf)
>> -                               unzipped_len = pstore_decompress(buf,
>> -                                                       big_oops_buf, size,
>> +                               unzipped_len = pstore_decompress(
>> +                                                       record.buf,
>> +                                                       big_oops_buf,
>> +                                                       record.size,
>>                                                         big_oops_buf_sz);
>>
>>                         if (unzipped_len > 0) {
>> -                               if (ecc_notice_size)
>> +                               if (record.ecc_notice_size)
>>                                         memcpy(big_oops_buf + unzipped_len,
>> -                                              buf + size, ecc_notice_size);
>> -                               kfree(buf);
>> -                               buf = big_oops_buf;
>> -                               size = unzipped_len;
>> -                               compressed = false;
>> +                                              record.buf + recorrecord.size,
>
> A typo on record.size.

Thanks! Yeah, 0-day noticed this too. I've refreshed the patches in my
tree with the correction now.

-Kees

-- 
Kees Cook
Pixel Security
