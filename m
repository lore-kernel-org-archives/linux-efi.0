Return-Path: <SRS0=rgVR=EK=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28EBAC2D0A3
	for <linux-efi@archiver.kernel.org>; Wed,  4 Nov 2020 23:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C980F20825
	for <linux-efi@archiver.kernel.org>; Wed,  4 Nov 2020 23:28:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="job0xAvO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732754AbgKDX2H (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Wed, 4 Nov 2020 18:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732765AbgKDX1O (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Wed, 4 Nov 2020 18:27:14 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA215C0613CF
        for <linux-efi@vger.kernel.org>; Wed,  4 Nov 2020 15:27:12 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id o70so376499ybc.1
        for <linux-efi@vger.kernel.org>; Wed, 04 Nov 2020 15:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YQrtMynYNNBwA8qq+ZyFclPN8/NJmA2N+Z24IBupICg=;
        b=job0xAvOoHrj/Gs5xydhQoDZ95FGoulUAPl0tsZzub/IjydlL0DoXac6xuDafHxiMj
         xbBzqUnzi/vrC9cvqHGiVDXhvkEfnBSdcCVRBwbGLlqTzeCWvmIGhvFE3NDFaN0yX3WE
         23BS1Wjxm01fz7J/FHedupmqAGLiFUlKaZhtLBUwBqX10IbngZnGDxm0W536+o9I+Ybu
         Bybkimi5p5LvRkr7TwkbymtB57gSlEuyapz2EthlZodsWm1qMn03FTE0T9JQ3sGNWkMC
         /rawXIbTFGM1G98+nQ4hwIXNOHKBxr+VxkfBUAu8mr6kZlUMgmELFj44XQeZdmeuBTqt
         vhFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YQrtMynYNNBwA8qq+ZyFclPN8/NJmA2N+Z24IBupICg=;
        b=dx1xMbefJtjosYT3DmxExYM1JjhJ9ajAq3Jhuk84EN7EdiV8Z1ACa26e/qgo2bomLY
         oYkLB4NqWcR0uaIyhDoz6nVqCS+Tr4/q3UDKDkDfVKbqZN1uPYmHvH757c0m9PkMJghe
         X2Of3r1uVl/nYoMFbAHHVfBUaArp3FqT4rw9zyTxop9uLz8WAzWJuFArldDHb4jamKSU
         G0J0oiv3qhaoEdR1WZVWH7vw4VmvBT1YftxJzI90RD+Iz3cqsK97ppzMYiaDSJcxby81
         VIWL4w3rQPkMsXWkuAHVLgiCjh2q89svridZwDcwjJe2U5hfXDNNKLyUuNfgOLk688xi
         LXJw==
X-Gm-Message-State: AOAM532xwUPadZ2OaOu22ZjM3u2MAiNXCllyBY4+tdFGfjI47dnKJ3+r
        /xMO4714/TAjB9urCpcms4zlc3DNNzjKOAAt90UVgw==
X-Google-Smtp-Source: ABdhPJyNbMhviT+FJksEuqeKYfy5J/iGJkuVO0TewBoC8SzBUDNxl7f+pTldy3QpUzrxbBlDMcuRt52i3FHGGQ8bYBM=
X-Received: by 2002:a25:7452:: with SMTP id p79mr310777ybc.346.1604532432071;
 Wed, 04 Nov 2020 15:27:12 -0800 (PST)
MIME-Version: 1.0
References: <20201104232356.4038506-1-saravanak@google.com>
In-Reply-To: <20201104232356.4038506-1-saravanak@google.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 4 Nov 2020 15:26:36 -0800
Message-ID: <CAGETcx9LRj9s=VA4Eck1=xaSq3FhHMRzxRLr=pZehxsEb0NGHQ@mail.gmail.com>
Subject: Re: [PATCH v1 00/18] Refactor fw_devlink to significantly improve
 boot time
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Android Kernel Team <kernel-team@android.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On Wed, Nov 4, 2020 at 3:23 PM Saravana Kannan <saravanak@google.com> wrote:
>
> The current implementation of fw_devlink is very inefficient because it
> tries to get away without creating fwnode links in the name of saving
> memory usage. Past attempts to optimize runtime at the cost of memory
> usage were blocked with request for data showing that the optimization
> made significant improvement for real world scenarios.
>
> We have those scenarios now. There have been several reports of boot
> time increase in the order of seconds in this thread [1]. Several OEMs
> and SoC manufacturers have also privately reported significant
> (350-400ms) increase in boot time due to all the parsing done by
> fw_devlink.
>
> So this patch series refactors fw_devlink to be more efficient. The key
> difference now is the addition of support for fwnode links -- just a few
> simple APIs. This also allows most of the code to be moved out of
> firmware specific (DT mostly) code into driver core.
>
> This brings the following benefits:
> - Instead of parsing the device tree multiple times (complexity was
>   close to O(N^3) where N in the number of properties) during bootup,
>   fw_devlink parses each fwnode node/property only once and creates
>   fwnode links. The rest of the fw_devlink code then just looks at these
>   fwnode links to do rest of the work.
>
> - Makes it much easier to debug probe issue due to fw_devlink in the
>   future. fw_devlink=on blocks the probing of devices if they depend on
>   a device that hasn't been added yet. With this refactor, it'll be very
>   easy to tell what that device is because we now have a reference to
>   the fwnode of the device.
>
> - Much easier to add fw_devlink support to ACPI and other firmware
>   types. A refactor to move the common bits from DT specific code to
>   driver core was in my TODO list as a prerequisite to adding ACPI
>   support to fw_devlink. This series gets that done.
>
> Tomi/Laurent/Grygorii,
>
> If you can test this series, that'd be great!
>
> Thanks,
> Saravana
>
> [1] - https://lore.kernel.org/linux-pm/CAGETcx-aiW251dhEXT1GNb9bi6YcX8W=jLBrro5CnPuEjGL09g@mail.gmail.com/

Forgot the update this link in the cover letter. Here's a much better
link to the thread that discusses boot time regression:
https://lore.kernel.org/linux-omap/ea02f57e-871d-cd16-4418-c1da4bbc4696@ti.com/


-Saravana
