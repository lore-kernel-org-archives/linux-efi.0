From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 03/18] pstore: Avoid race in module unloading
Date: Tue, 7 Mar 2017 08:18:40 -0800
Message-ID: <CAGXu5jLWBFVH92PK+vPAsv5sDyLCX6=85NWFXNetC0JDBNUUqQ@mail.gmail.com>
References: <1488837332-71582-1-git-send-email-keescook@chromium.org>
 <1488837332-71582-4-git-send-email-keescook@chromium.org>
 <CADWwUUZAxwUqHU9eRrtP5Hk7KO9KkyvdBy7Z5Xehwhv43fvZVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CADWwUUZAxwUqHU9eRrtP5Hk7KO9KkyvdBy7Z5Xehwhv43fvZVQ@mail.gmail.com>
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

On Tue, Mar 7, 2017 at 8:16 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> Hi Kees,
>
> On Tue, Mar 7, 2017 at 6:55 AM, Kees Cook <keescook@chromium.org> wrote:
>> Technically, it might be possible for struct pstore_info to go out of
>> scope after the module_put(), so report the backend name first.
>
> But in that case, using pstore will crash the kernel anyway, right?
> If so, why pstore doesn't keep a reference until unregister?
> Do I miss something?

I could be wrong with this, since the backend can't call unregister
until register has finished... I'll drop this patch.

-Kees

>
> Thanks,
> Namhyung
>
>
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  fs/pstore/platform.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
>> index 074fe85a2078..d69ef8a840b9 100644
>> --- a/fs/pstore/platform.c
>> +++ b/fs/pstore/platform.c
>> @@ -722,10 +722,10 @@ int pstore_register(struct pstore_info *psi)
>>          */
>>         backend = psi->name;
>>
>> -       module_put(owner);
>> -
>>         pr_info("Registered %s as persistent store backend\n", psi->name);
>>
>> +       module_put(owner);
>> +
>>         return 0;
>>  }
>>  EXPORT_SYMBOL_GPL(pstore_register);
>> --
>> 2.7.4
>>



-- 
Kees Cook
Pixel Security
