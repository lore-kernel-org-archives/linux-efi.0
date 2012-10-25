From: Mike Waychison <mikew@google.com>
Subject: Re: [PATCH v2 3/5] efi_pstore: Remove a logic erasing entries from a
 write callback to hold multiple logs
Date: Thu, 25 Oct 2012 13:21:48 -0700
Message-ID: <CAGTjWtAUv=HzOGPDeDuTb_6z81bnSQ-F7DDERZ2tqmfaP4wXwQ@mail.gmail.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D4138889AD@USINDEM103.corp.hds.com>
 <CAGTjWtDVZGq7VKou10xC-zJXGmane_kKjGo1xMjgPUkKAedFqQ@mail.gmail.com> <A5ED84D3BB3A384992CBB9C77DEDA4D413889851@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D413889851@USINDEM103.corp.hds.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>, "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>, "dzickus@redhat.com" <dzickus@redhat.com>, "dle-develop@lists.sourceforge.net" <dle-develop@lists.sourceforge.net>, Satoru Moriya <satoru.moriya@hds.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 25, 2012 at 1:03 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
>> > -               list_del(&found->list);
>> > +       sprintf(name, "dump-type%u-%u-%lu", type, part,
>> > +               get_seconds());
>>
>> Actually, nothing seems to be ensuring that the value used here ends up being the same as the ctime :\  Consider what happens if the
>> get_seconds() call here happens at second N, and the i_ctime is collected at time N+1. The object wouldn't be able to be deleted after
>> patch 4/5 is applied.  How can we better ensure that the i_ctime is the same value as serialized into the efi var name here?
>
>  i_ctime of pstore file system is different from normal file systems.
> As I said in patch v1, i_ctime of pstore means the date that the record was "originally" stored.
>
> I_ctime is always set to N.
> Here is the scenario.
>
> 1.  writing time
>     - get_seconds() call here happens at second N
>     - "N" is stored to a variable name
>
> 2. System reboots...
> 3. System boots up...
>
> 4. reading time
>    - pstore calls a read callback, efi_pstore_read()
>    -  efi_pstore_read extracts ctime, "N", from the virable name

Ah, I accidentally glossed over this bit.  Thanks for correcting me :)

>    -  efi_pstore passes "N" to pstore file system
>     - pstore create a file, /dev/pstore/dmesg* and set "N" to i_ctime
>
> Pstore file system doesn't set i_ctime by itself but set ctime passed by platform drivers.
>

So doesn't this break erasing of existing dumps in pstore-efivars?
Unless efi_pstore_read still understands the older variable name
formats, users will be stranded with dumps consuming space in efivars
that aren't exported via pstore anymore.
