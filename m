From: Seiji Aguchi <seiji.aguchi@hds.com>
Subject: [PATCH v6 0/7] efi_pstore: multiple event logging support
Date: Wed, 14 Nov 2012 20:24:36 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138CA679@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>, "anton.vorontsov@linaro.org" <anton.vorontsov@linaro.org>, "mikew@google.com" <mikew@google.com>, "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>, "dzickus@redhat.com" <dzickus@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Cc: "dle-develop@lists.sourceforge.net" <dle-develop@lists.sourceforge.net>, Satoru Moriya <satoru.moriya@hds.com>
List-Id: linux-efi@vger.kernel.org

v5 -> v6
   - Add ctime to an argument of efi_pstore_erase to build successfully
     in case where CONFIG_PTORE=n is specified. (Patch 4/7)
   - Add count to an argument of efi_pstore_erase and efi_pstore_write to
     build successfully in case where CONFIG_PTORE=n is specified (Patch 5/7)
   - They are removed in a patchset v5 by mistake even though they were fixed
     in a patchset v4.
 
   By applying a patchset v6, kernel can be built with both CONFIG_PSTORE=y and
   CONFIG_PSTORE=n.
   Also, it can be built with both CONFIG_PSTORE_CONSOLE=y and
   CONFIG_PSTORE_CONSOLE=n.

v4 -> v5
   - Rebase to 3.7-rc5
   - Add count to an argument of a write callback executed in pstore_console_write()
     to build successfully in case where CONSIG_PSTORE_CONSOLE=y is specified. (Patch 5/7)

v3 -> v4
   - Rebase to 3.7-rc3
   - Add ctime to an argument of efi_pstore_erase to build successfully
     in case where CONFIG_PTORE=n is specified. (Patch 4/7)
   - Add count to an argument of efi_pstore_erase and efi_pstore_write to
     build successfully in case where CONFIG_PTORE=n is specified (Patch 5/7)
   - Fix a white space damage (Patch 6/7)
   - Modify a logic checking a 3-variable format of a variable name (Patch 7/7)

v2 -> v3
   - Create patches 6/7 and 7/7 to work with an existing format of variable name

v1 -> v2
   - Separate into 5 patches in accordance with Mike's comment
   - Erase an extra line of comment in patch 1/5

[Issue]

    Currently, efi_pstore driver simply overwrites existing panic messages in NVRAM.
    So, in the following scenario, we will lose 1st panic messages.

    1. kernel panics.
    2. efi_pstore is kicked and writes panic messages to NVRAM.
    3. system reboots.
    4. kernel panics again before a user checks the 1st panic messages in NVRAM.

[Solution]

   Solutions of this problem has been discussed among Tony, Matthew, Don, Mike and me.

   http://marc.info/?l=linux-kernel&m=134273270704586&w=2

   And there are two possible solutions right now.
     - First one is introducing some policy overwriting existing logs.
     - Second one is simply holding multiple log without overwriting any entries.

   We haven't decided the overwriting policy which is reasonable to all users yet.
   But I believe we agree that just holding multiple logs is a reasonable way.

   We may need further discussions to find the possibility of introducing overwriting
   policy, especially getting critical messages in multiple oops case.
   But I would like to begin with a simple and reasonable way to everyone.
   So, this patch takes an approach just holding multiple logs.

Seiji Aguchi (7):
  efi_pstore: Check remaining space with QueryVariableInfo() before
    writing data
  efi_pstore: Add a logic erasing entries to an erase callback
  efi_pstore: Remove a logic erasing entries from a write callback to
    hold multiple logs
  efi_pstore: Add ctime to argument of erase callback
  efi_pstore: Add a sequence counter to a variable name
  efi_pstore: Add a format check for an existing variable name at
    reading time
  efi_pstore: Add a format check for an existing variable name at
    erasing time

 drivers/acpi/apei/erst.c   |   16 ++--
 drivers/firmware/efivars.c |  163 ++++++++++++++++++++++++++++++-------------
 fs/pstore/inode.c          |    7 ++-
 fs/pstore/internal.h       |    2 +-
 fs/pstore/platform.c       |   13 ++--
 fs/pstore/ram.c            |    9 +--
 include/linux/efi.h        |    1 +
 include/linux/pstore.h     |    6 +-
 8 files changed, 144 insertions(+), 73 deletions(-)

