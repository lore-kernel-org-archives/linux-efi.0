From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [RFC 0/3] Add capsule update using error on close semantics
Date: Wed, 29 Apr 2015 16:07:39 -0700
Message-ID: <1430348859.2189.37.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

This is a straw man implementation.  The three patches firstly thread
the needed ->flush() file op through sysfs and kernfs.  The next one
extracts transaction buffer handling from firmware_class.c and makes it
generic in a lib helper and the third patch adds a bare bones capsule
update (I suspect the latter needs more work, since it doesn't implement
the scatterlist).

James Bottomley (3):
  sysfs,kernfs: add flush operation
  firmware_class: split out transaction helpers
  efi: add capsule update capability via sysfs

 drivers/base/firmware_class.c      | 117 ++++---------------------------
 drivers/firmware/efi/Makefile      |   2 +-
 drivers/firmware/efi/capsule.c     |  78 +++++++++++++++++++++
 drivers/firmware/efi/capsule.h     |   2 +
 drivers/firmware/efi/efi.c         |   8 +++
 fs/kernfs/file.c                   |  16 +++++
 fs/sysfs/file.c                    |  16 +++++
 include/linux/kernfs.h             |   2 +
 include/linux/sysfs.h              |   2 +
 include/linux/transaction_helper.h |  26 +++++++
 lib/Makefile                       |   2 +-
 lib/transaction_helper.c           | 137 +++++++++++++++++++++++++++++++++++++
 12 files changed, 304 insertions(+), 104 deletions(-)
 create mode 100644 drivers/firmware/efi/capsule.c
 create mode 100644 drivers/firmware/efi/capsule.h
 create mode 100644 include/linux/transaction_helper.h
 create mode 100644 lib/transaction_helper.c

James
