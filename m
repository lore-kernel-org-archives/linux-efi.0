From: Ge Song <ge.song@hxt-semitech.com>
Subject: [PATCH 0/2] Make capsules in a contiguous virtual space
Date: Tue, 19 Dec 2017 18:49:13 +0800
Message-ID: <1513680554-5682-1-git-send-email-ge.song@hxt-semitech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Ge Song <ge.song@hxt-semitech.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Recently we found it failed to update firmware through capsule update
mechanism in linux-4.14 and later version.

After some investigation, the reason is firmware expects capsules in a
contiguous virtual space and this assumption is not satisfied in recent
linux versions.

Ge Song (2):
  Revert "efi/capsule-loader: Use page addresses rather than struct page
    pointers"
  efi/capsule-loader: Request a contiguous virtual space for capsules

 drivers/firmware/efi/capsule-loader.c | 23 ++++++++++++++---------
 drivers/firmware/efi/capsule.c        |  7 +++----
 include/linux/efi.h                   |  4 ++--
 3 files changed, 19 insertions(+), 15 deletions(-)

-- 
2.7.4
